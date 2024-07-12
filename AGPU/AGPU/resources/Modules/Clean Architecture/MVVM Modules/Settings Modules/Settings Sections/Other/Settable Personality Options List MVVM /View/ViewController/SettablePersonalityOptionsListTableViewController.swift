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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.getData()
    }
    
    private func setUpNavigation() {
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .plain, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .label
        navigationItem.title = "Настройки личности"
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        self.dismiss(animated: true)
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
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.optionsCount()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.optionItem(index: indexPath.row).name
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        return cell
    }
}
