//
//  SavedWebPagesListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 12.04.2025.
//

import UIKit

protocol SavedWebPagesListTableViewControllerDelegate: AnyObject {
    func webPagesListUpdated()
}

final class SavedWebPagesListTableViewController: UIViewController {
    
    // MARK: - сервисы
    let viewModel = SavedWebPagesListViewModel()
    
    // MARK: - UI
    let tableView = UITableView()
    private let noWebPagesLabel = UILabel()
    
    weak var delegate: SavedWebPagesListTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        setUpLabel()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        
        let titleView = CustomTitleView(image: "online", title: "Web-страницы", frame: .zero)
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        let backButton = UIBarButtonItem(customView: button)
        
        let addButton = UIBarButtonItem(image: UIImage(named: "add"), style: .done, target: self, action: #selector(showAddWebPageAlert))
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
    
    func setUpAddButton() {
        let addButton = UIBarButtonItem(image: UIImage(named: "add"), style: .done, target: self, action: #selector(addButtonTapped))
        addButton.tintColor = .label
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc private func addButtonTapped() {
        showAddWebPageAlert()
    }
    
    func setUpEditButton() {
        let moveButton = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(moveWebPages))
        moveButton.tintColor = .label
        navigationItem.rightBarButtonItem = moveButton
    }
    
    @objc private func moveWebPages() {
        tableView.isEditing.toggle()
        setUpAddButton()
    }
    
    private func setUpTable() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SavedWebPagesListTableTableViewCell.self, forCellReuseIdentifier: SavedWebPagesListTableTableViewCell.identifier)
    }
    
    private func setUpLabel() {
        view.addSubview(noWebPagesLabel)
        noWebPagesLabel.text = "Нет страниц"
        noWebPagesLabel.font = .systemFont(ofSize: 18, weight: .medium)
        noWebPagesLabel.isHidden = true
        noWebPagesLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noWebPagesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noWebPagesLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.registerDataChangedHandler {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            if !self.viewModel.pages.isEmpty {
                self.noWebPagesLabel.isHidden = true
            } else {
                self.noWebPagesLabel.isHidden = false
            }
            self.delegate?.webPagesListUpdated()
        }
        viewModel.registerAlertHandler {
            let ok = UIAlertAction(title: "ОК", style: .default) { _ in
                self.showAddWebPageAlert()
            }
            self.showAlert(title: "Неверные URL!", message: "URL не является валидным", actions: [ok])
        }
        viewModel.registerItemChangedHandler { index in
            self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .left)
        }
        viewModel.getPages()
    }
}
