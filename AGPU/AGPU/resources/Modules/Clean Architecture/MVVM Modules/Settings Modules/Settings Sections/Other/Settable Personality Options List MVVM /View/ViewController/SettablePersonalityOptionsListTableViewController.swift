//
//  SettablePersonalityOptionsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 12.07.2024.
//

import UIKit

class SettablePersonalityOptionsListTableViewController: UITableViewController {

    // MARK: - сервисы
    private let viewModel = SettablePersonalityOptionsListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        let titleView = CustomTitleView(image: "gear", title: "Настройки личности", frame: .zero)
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .plain, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .label
        navigationItem.titleView = titleView
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        sendScreenWasClosedNotification()
        self.dismiss(animated: true)
    }
    
    private func setUpTable() {
        tableView.register(SettablePersonalityOptionTableViewCell.self, forCellReuseIdentifier: SettablePersonalityOptionTableViewCell.identifier)
    }
    
    private func bindViewModel() {
        viewModel.registerDataChangedHandler {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        viewModel.getData()
    }
    
    func showAlert() {
        
        let message = viewModel.createAlertMessage()
        
        let alertController = UIAlertController(title: message.0, message: message.1, preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = self.viewModel.createTextForPlaceHolder()
            textField.text = self.viewModel.getName()
        }
        
        let save = UIAlertAction(title: "Сохранить", style: .default) { [weak self] _ in
            if let name = alertController.textFields![0].text {
                if !name.isEmpty {
                    self?.viewModel.saveName(name: name)
                }
            }
        }
        let cancel = UIAlertAction(title: "Отмена", style: .destructive)
        alertController.addAction(save)
        alertController.addAction(cancel)
        present(alertController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = viewModel.options[indexPath.row]
        switch option.id {
        case 1:
            showAlert()
        case 2:
            let vc = CommunicationStyleVariantsListTableViewController()
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
        HapticsManager.shared.hapticFeedback()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.optionsCount()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettablePersonalityOptionTableViewCell.identifier, for: indexPath) as? SettablePersonalityOptionTableViewCell else {return UITableViewCell()}
        cell.configure(option: viewModel.optionItem(index: indexPath.row))
        return cell
    }
}

// MARK: - CommunicationStyleVariantsListTableViewControllerDelegate
extension SettablePersonalityOptionsListTableViewController: CommunicationStyleVariantsListTableViewControllerDelegate {
    
    func styleWasSelected() {
        viewModel.getData()
    }
}
