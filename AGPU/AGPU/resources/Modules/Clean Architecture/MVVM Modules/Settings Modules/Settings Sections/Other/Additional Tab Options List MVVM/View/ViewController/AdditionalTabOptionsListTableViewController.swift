//
//  AdditionalTabOptionsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 25.12.2024.
//

import UIKit

final class AdditionalTabOptionsListTableViewController: UITableViewController {
    
    // MARK: - сервисы
    private let viewModel = AdditionalTabOptionsListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        let titleView = CustomTitleView(image: "choose", title: viewModel.titleForNavigation(), frame: .zero)
        navigationItem.titleView = titleView
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
    
    private func setUpTable() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func bindViewModel() {
        viewModel.registerDataChangedHandler {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        viewModel.registerItemChangedHandler { index in
            DispatchQueue.main.async {
                self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .left)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            
            let variant = self.viewModel.variantItem(index: indexPath.row)
            
            if self.viewModel.isVariantSelected(index: indexPath.row) && variant != .button {
                let editName = UIAction(title: "Редактировать", image: UIImage(named: "edit")) { _ in
                    self.showEditTabAlert(variant: variant)
                }
                return UIMenu(title: variant.rawValue, children: [
                    editName
                ])
            } else {
                return nil
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let variant = viewModel.variantItem(index: indexPath.row)
        if variant == .button {
            let vc = ASPUButtonOptionsListTableViewController()
            vc.isSettings = true
            navigationController?.pushViewController(vc, animated: true)
        }
        viewModel.selectVariant(index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.variantsCount()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let variant = viewModel.variantItem(index: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.tintColor = .systemGreen
        cell.textLabel?.text = viewModel.textForVariant(variant: variant)
        cell.textLabel?.textColor = viewModel.isVariantSelected(index: indexPath.row) ? .systemGreen : .label
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        cell.accessoryType = viewModel.isVariantSelected(index: indexPath.row) ? .checkmark : .none
        return cell
    }
}

extension AdditionalTabOptionsListTableViewController {
    
    func showEditTabAlert(variant: AdditionalTabVariants) {
        
        let alertVC = UIAlertController(title: viewModel.createEditAlertMessage().0, message: viewModel.createEditAlertMessage().1, preferredStyle: .alert)
        
        alertVC.addTextField { (textField) in
            textField.placeholder = "Название"
            textField.text = self.viewModel.textForVariant(variant: variant)
        }
        
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { _ in
            if let name = alertVC.textFields![0].text {
                if !name.isEmpty {
                    if name.count <= 15 {
                        self.viewModel.editText(variant: variant, text: name)
                    } else {
                        self.showAlert(title: "Слишком много текста!", message: "Количество символов не должно превышать 15", actions: [UIAlertAction(title: "ОК", style: .default) { _ in self.showEditTabAlert(variant: variant)}])
                    }
                }
            }
        }
        
        let resetsaveAction = UIAlertAction(title: "Сбросить", style: .destructive) { _ in
            self.viewModel.resetTitle(variant: variant)
        }
        
        let cancel = UIAlertAction(title: "Отмена", style: .default) { _ in}
        
        alertVC.addAction(saveAction)
        alertVC.addAction(resetsaveAction)
        alertVC.addAction(cancel)
        
        SpeechSynthesizerManager.shared.checkIsSaying(text: "\(alertVC.title ?? "") \(alertVC.message ?? "")")
        present(alertVC, animated: true)
    }
}
