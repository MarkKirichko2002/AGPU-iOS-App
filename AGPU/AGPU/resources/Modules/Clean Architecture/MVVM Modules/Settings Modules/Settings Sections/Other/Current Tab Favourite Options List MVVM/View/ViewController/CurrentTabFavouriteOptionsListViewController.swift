//
//  CurrentTabFavouriteOptionsListViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 13.12.2024.
//

import UIKit

final class CurrentTabFavouriteOptionsListViewController: UIViewController {

    weak var delegate: ASPUButtonFavouriteActionsListTableViewControllerDelegate?
    var currentTitle: String
    
    // MARK: - UI
    private let noActionsLabel = UILabel()
    private let tableView = UITableView()
    
    // MARK: - сервисы
    let viewModel: CurrentTabFavouriteOptionsListViewModel
    
    init(title: String) {
        self.viewModel = CurrentTabFavouriteOptionsListViewModel(title: title)
        self.currentTitle = title
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
        let titleView = CustomTitleView(image: "star", title: currentTitle.getCurrentTabName(), frame: .zero)
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        let backButton = UIBarButtonItem(customView: button)
        
        let addButton = UIBarButtonItem(image: UIImage(named: "add"), style: .done, target: self, action: #selector(addButtonTapped))
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
        let vc = CurrentTabOptionsListTableViewController(title: viewModel.title)
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
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
        view.addSubview(noActionsLabel)
        noActionsLabel.text = "Нет действий"
        noActionsLabel.font = .systemFont(ofSize: 18, weight: .medium)
        noActionsLabel.isHidden = true
        noActionsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noActionsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noActionsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.registerDataChangedHandler {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            if !self.viewModel.options.isEmpty {
                self.noActionsLabel.isHidden = true
            } else {
                self.noActionsLabel.isHidden = false
            }
        }
        viewModel.getOptions()
    }
}
