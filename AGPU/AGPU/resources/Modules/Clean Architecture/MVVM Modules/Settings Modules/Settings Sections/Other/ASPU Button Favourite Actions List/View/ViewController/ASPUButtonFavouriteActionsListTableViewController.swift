//
//  ASPUButtonFavouriteActionsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 27.04.2024.
//

import UIKit

protocol ASPUButtonFavouriteActionsListTableViewControllerDelegate: AnyObject {
    func actionWasSelected(action: ASPUButtonActions)
}

class ASPUButtonFavouriteActionsListTableViewController: UIViewController {
    
    var isSettings = false
    weak var delegate: ASPUButtonFavouriteActionsListTableViewControllerDelegate?
    
    // MARK: - UI
    private let noActionsLabel = UILabel()
    private let tableView = UITableView()
    
    // MARK: - ASPUButtonFavouriteActionsListViewModel
    let viewModel = ASPUButtonFavouriteActionsListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        setUpLabel()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        
        let titleView = CustomTitleView(image: "star", title: "Избранное", frame: .zero)
        
        if isSettings {
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
        } else {
            let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .plain, target: self, action: #selector(closeScreen))
            closeButton.tintColor = .label
            let addButton = UIBarButtonItem(image: UIImage(named: "add"), style: .done, target: self, action: #selector(addButtonTapped))
            addButton.tintColor = .label
            navigationItem.titleView = titleView
            navigationItem.leftBarButtonItem = closeButton
            navigationItem.rightBarButtonItem = addButton
        }
    }
    
    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        sendScreenWasClosedNotification()
        dismiss(animated: true)
    }
    
    func setUpAddButton() {
        let addButton = UIBarButtonItem(image: UIImage(named: "add"), style: .done, target: self, action: #selector(addButtonTapped))
        addButton.tintColor = .label
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc private func addButtonTapped() {
        let vc = ASPUButtonAllActionsListTableViewController()
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
            if !self.viewModel.actions.isEmpty {
                self.noActionsLabel.isHidden = true
            } else {
                self.noActionsLabel.isHidden = false
            }
        }
        viewModel.getActions()
    }
}
