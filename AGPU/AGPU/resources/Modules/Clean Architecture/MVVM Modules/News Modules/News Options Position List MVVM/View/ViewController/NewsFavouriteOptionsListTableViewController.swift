//
//  NewsFavouriteOptionsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 16.06.2024.
//

import UIKit

final class NewsFavouriteOptionsListTableViewController: UIViewController {
    
    var isSettings = false
    
    // MARK: - UI
    private let noOptionsLabel = UILabel()
    private let tableView = UITableView()
    
    // MARK: - сервисы
    private let viewModel = NewsFavouriteOptionsListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        setUpLabel()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        setUpNavigationTitle()
        if isSettings {
            setUpBackButton()
        } else {
            setUpCloseButton()
        }
        setUpAddButton()
    }
    
    func setUpNavigationTitle() {
        let titleView = CustomTitleView(image: "star", title: "Список опций", frame: .zero)
        navigationItem.titleView = titleView
    }
    
    func setUpCloseButton() {
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .done, target: self, action: #selector(close))
        closeButton.tintColor = .label
        navigationItem.leftBarButtonItem = closeButton
    }
    
    @objc private func close() {
        HapticsManager.shared.hapticFeedback()
        dismiss(animated: true)
    }
    
    func setUpBackButton() {
        
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        let backButton = UIBarButtonItem(customView: button)
        
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
    
    func setUpAddButton() {
        let addButton = UIBarButtonItem(image: UIImage(named: "add"), style: .done, target: self, action: #selector(addButtonTapped))
        addButton.tintColor = .label
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc private func addButtonTapped() {
        let vc = AllNewsOptionsListTableViewController()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func setUpEditButton(title: String) {
        let moveButton = UIBarButtonItem(title: title, style: .done, target: self, action: #selector(moveOptions))
        moveButton.tintColor = .label
        navigationItem.rightBarButtonItem = moveButton
    }
    
    @objc private func moveOptions() {
        tableView.isEditing.toggle()
        setUpAddButton()
    }
    
    private func setUpTable() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func setUpLabel() {
        view.addSubview(noOptionsLabel)
        noOptionsLabel.text = "Нет опций"
        noOptionsLabel.font = .systemFont(ofSize: 18, weight: .medium)
        noOptionsLabel.isHidden = true
        noOptionsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noOptionsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noOptionsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.registerDataChangedHandler {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            if !self.viewModel.options.isEmpty {
                self.noOptionsLabel.isHidden = true
            } else {
                self.noOptionsLabel.isHidden = false
            }
        }
        viewModel.getOptions()
    }
}

// MARK: - AllNewsOptionsListTableViewControllerDelegate
extension NewsFavouriteOptionsListTableViewController: AllNewsOptionsListTableViewControllerDelegate {
    
    func optionWasAdded() {
        viewModel.getOptions()
    }
}

// MARK: - UITableViewDelegate
extension NewsFavouriteOptionsListTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if tableView.isEditing {
            viewModel.updateOptions(options: viewModel.options, sourceIndexPath.row, destinationIndexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            
            let positionAction = UIAction(title: "Позиция", image: UIImage(named: "number")) { _ in
                tableView.isEditing.toggle()
                self.setUpEditButton(title: "Готово")
            }
            
            return UIMenu(title: self.viewModel.options[indexPath.row].name, children: [
                positionAction
            ])
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let option = viewModel.optionItem(index: indexPath.row)
            viewModel.deleteOption(option: option)
        }
    }
}

// MARK: - UITableViewDataSource
extension NewsFavouriteOptionsListTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.options[indexPath.row].name
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        return cell
    }
}
