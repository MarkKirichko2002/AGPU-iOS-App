//
//  DocumentsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 19.02.2024.
//

import UIKit

class DocumentsListTableViewController: UIViewController {

    // MARK: - сервисы
    let viewModel = DocumentsListViewModel()
    
    // MARK: - UI
    let tableView = UITableView()
    private let noDocsLabel = UILabel()
    
    var document = DocumentModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        setUpLabel()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        
        let titleView = CustomTitleView(image: "document", title: "Документы", frame: .zero)
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        let backButton = UIBarButtonItem(customView: button)
        
        let moveButton = UIBarButtonItem(title: "Править", style: .done, target: self, action: #selector(moveDocuments))
        moveButton.tintColor = .label
        
        navigationItem.titleView = titleView
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = moveButton
    }
    
    @objc private func back() {
        sendScreenWasClosedNotification()
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func moveDocuments() {
        if tableView.isEditing {
            tableView.isEditing = false
        } else {
            tableView.isEditing = true
        }
    }
    
    private func setUpTable() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: DocumentTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: DocumentTableViewCell.identifier)
    }
    
    private func setUpLabel() {
        view.addSubview(noDocsLabel)
        noDocsLabel.text = "Нет документов"
        noDocsLabel.font = .systemFont(ofSize: 18, weight: .medium)
        noDocsLabel.isHidden = true
        noDocsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noDocsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noDocsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.registerDataChangedHandler {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            if !self.viewModel.documents.isEmpty {
                self.noDocsLabel.isHidden = true
            } else {
                self.noDocsLabel.isHidden = false
            }
        }
        viewModel.getDocuments()
    }
}
