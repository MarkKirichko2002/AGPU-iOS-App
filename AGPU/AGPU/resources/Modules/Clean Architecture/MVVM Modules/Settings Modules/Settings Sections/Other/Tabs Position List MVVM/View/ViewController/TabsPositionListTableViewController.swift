//
//  TabsPositionListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 23.03.2024.
//

import UIKit

final class TabsPositionListTableViewController: UITableViewController {
    
    // MARK: - сервисы
    private let viewModel = TabsPositionListTableViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        setUpNavigationTitle()
        setUpBackButton()
        setUpEditButton(title: "Править")
    }
    
    func setUpNavigationTitle() {
        let titleView = CustomTitleView(image: "sections icon", title: "Список вкладок", frame: .zero)
        navigationItem.titleView = titleView
    }
    
    func setUpBackButton() {
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        let backButton = UIBarButtonItem(customView: button)
        backButton.tintColor = .label
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
    
    func setUpEditButton(title: String) {
        let moveButton = UIBarButtonItem(title: title, style: .done, target: self, action: #selector(moveTabs))
        moveButton.tintColor = .label
        navigationItem.rightBarButtonItem = moveButton
    }
    
    @objc private func moveTabs() {
        if tableView.isEditing {
            setUpEditButton(title: "Править")
            tableView.isEditing = false
        } else {
            setUpEditButton(title: "Готово")
            tableView.isEditing = true
        }
    }
    
    private func setUpTable() {
        tableView.register(TabItemTableViewCell.self, forCellReuseIdentifier: TabItemTableViewCell.identifier)
    }
    
    private func bindViewModel() {
        viewModel.registerDataChangedHandler {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        viewModel.getData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showEditAlert(tab: viewModel.tabItem(index: indexPath.row))
        tableView.deselectRow(at: indexPath, animated: true)
        HapticsManager.shared.hapticFeedback()
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if tableView.isEditing {
            viewModel.saveTabsPosition(sourceIndexPath.row, destinationIndexPath.row)
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tabs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TabItemTableViewCell.identifier, for: indexPath) as? TabItemTableViewCell else {return UITableViewCell()}
        cell.configure(tab: viewModel.tabs[indexPath.row])
        return cell
    }
}

extension TabsPositionListTableViewController {
    
    func showEditAlert(tab: TabModel) {
        let title = viewModel.convertTabName(tab: tab)
        let editAction = UIAlertAction(title: "Название", style: .default) { _ in
            self.showEditTabAlert(tab: tab)
        }
        let actionsList = UIAlertAction(title: "Действия", style: .default) { _ in
            let vc = CurrentTabFavouriteOptionsListViewController(title: self.viewModel.getTabName(tab: tab))
            self.navigationController?.pushViewController(vc, animated: true)
        }
        let cancel = UIAlertAction(title: "Отмена", style: .destructive)
        self.showAlert(title: "Вкладка \"\(title)\"", message: "что нужно изменить для вкладки?", actions: [editAction, actionsList, cancel])
    }
    
    func showEditTabAlert(tab: TabModel) {
        
        let alertVC = UIAlertController(title: viewModel.createEditAlertMessage().0, message: viewModel.createEditAlertMessage().1, preferredStyle: .alert)
        
        alertVC.addTextField { (textField) in
            textField.placeholder = "Название"
            textField.text = tab.name
        }
        
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { _ in
            if let name = alertVC.textFields![0].text {
                if !name.isEmpty {
                    if name.count <= 15 {
                        self.viewModel.editText(tab: tab, text: name)
                    } else {
                        self.showAlert(title: "Слишком много текста!", message: "Количество символов не должно превышать 15", actions: [UIAlertAction(title: "ОК", style: .default) { _ in self.showEditTabAlert(tab: tab)}])
                    }
                }
            }
        }
        
        let resetsaveAction = UIAlertAction(title: "Сбросить", style: .destructive) { _ in
            self.viewModel.resetTitle(tab: tab)
        }
        
        let cancel = UIAlertAction(title: "Отмена", style: .default) { _ in
            self.showEditAlert(tab: tab)
        }
        
        alertVC.addAction(saveAction)
        alertVC.addAction(resetsaveAction)
        alertVC.addAction(cancel)
        
        SpeechSynthesizerManager.shared.checkIsSaying(text: "\(alertVC.title ?? "") \(alertVC.message ?? "")")
        present(alertVC, animated: true)
    }
}
