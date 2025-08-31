//
//  FavouriteTitlesListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 12.08.2025.
//

import UIKit

protocol FavouriteTitlesListTableViewControllerDelegate: AnyObject {
    func titleWasSelected(title: String)
}

final class FavouriteTitlesListTableViewController: UIViewController {

    // MARK: - UI
    private let noTitlesLabel = UILabel()
    private let tableView = UITableView()
    
    // MARK: - сервисы
    let viewModel: FavouriteTitlesListViewModel
    
    weak var delegate: FavouriteTitlesListTableViewControllerDelegate?
    var name = ""
    
    init(name: String) {
        self.name = name
        self.viewModel = FavouriteTitlesListViewModel(name: name)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        setUpLabel()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        let titleView = CustomTitleView(image: "star", title: name, frame: .zero)
        navigationItem.titleView = titleView
        setUpCloseButton()
        setUpAddButton()
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
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        dismiss(animated: true)
    }
    
    func setUpAddButton() {
        let addButton = UIBarButtonItem(image: UIImage(named: "add"), style: .done, target: self, action: #selector(addButtonTapped))
        addButton.tintColor = .label
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc private func addButtonTapped() {
        showAddTitleAlert()
    }
    
    func setUpEditButton(title: String) {
        let moveButton = UIBarButtonItem(title: title, style: .done, target: self, action: #selector(moveActions))
        moveButton.tintColor = .label
        navigationItem.rightBarButtonItem = moveButton
    }
    
    @objc private func moveActions() {
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
        view.addSubview(noTitlesLabel)
        noTitlesLabel.text = "Нет названий"
        noTitlesLabel.font = .systemFont(ofSize: 18, weight: .medium)
        noTitlesLabel.isHidden = true
        noTitlesLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noTitlesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noTitlesLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.registerDataChangedHandler {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            if !self.viewModel.titles.isEmpty {
                self.noTitlesLabel.isHidden = true
            } else {
                self.noTitlesLabel.isHidden = false
            }
        }
        viewModel.registerItemChangedHandler { index in
            DispatchQueue.main.async {
                self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .left)
            }
        }
        viewModel.getTitles()
    }
}
