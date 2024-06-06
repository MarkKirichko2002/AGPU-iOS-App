//
//  ContactsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 05.06.2024.
//

import UIKit

protocol ContactsListTableViewControllerDelegate: AnyObject {
    func listUpdated()
}

class ContactsListTableViewController: UIViewController {

    // MARK: - сервисы
    let viewModel = ContactsListViewModel()
    
    // MARK: - UI
    let tableView = UITableView()
    private let noContactsLabel = UILabel()
    
    var contact = ContactModel()
    
    weak var delegate: ContactsListTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        setUpLabel()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        
        let titleView = CustomTitleView(image: "contacts icon", title: "Контакты", frame: .zero)
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        let backButton = UIBarButtonItem(customView: button)
        
        let addButton = UIBarButtonItem(image: UIImage(named: "add"), style: .done, target: self, action: #selector(showAddContactAlert))
        addButton.tintColor = .label
        
        navigationItem.titleView = titleView
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setUpTable() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ContactsListTableViewCell.self, forCellReuseIdentifier: ContactsListTableViewCell.identifier)
    }
    
    private func setUpLabel() {
        view.addSubview(noContactsLabel)
        noContactsLabel.text = "Нет контактов"
        noContactsLabel.font = .systemFont(ofSize: 18, weight: .medium)
        noContactsLabel.isHidden = true
        noContactsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noContactsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noContactsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.registerDataChangedHandler {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            if !self.viewModel.contacts.isEmpty {
                self.noContactsLabel.isHidden = true
            } else {
                self.noContactsLabel.isHidden = false
            }
            self.delegate?.listUpdated()
        }
        viewModel.getContacts()
    }
}
