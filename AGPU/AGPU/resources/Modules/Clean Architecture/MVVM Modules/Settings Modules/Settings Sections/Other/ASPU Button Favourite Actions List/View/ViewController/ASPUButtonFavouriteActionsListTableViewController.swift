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

class ASPUButtonFavouriteActionsListTableViewController: UITableViewController {
    
    var isSettings = false
    weak var delegate: ASPUButtonFavouriteActionsListTableViewControllerDelegate?
    
    // MARK: - ASPUButtonFavouriteActionsListViewModel
    let viewModel = ASPUButtonFavouriteActionsListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
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
        dismiss(animated: true)
    }
    
    @objc private func addButtonTapped() {
        let vc = ASPUButtonAllActionsListTableViewController()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setUpTable() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func bindViewModel() {
        viewModel.getActions()
        viewModel.registerDataChangedHandler {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let action = viewModel.actionItem(index: indexPath.row)
            viewModel.deleteAction(action: action)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let action = viewModel.actionItem(index: indexPath.row)
        if !isSettings {
            delegate?.actionWasSelected(action: action)
            dismiss(animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.actionsCount()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let action = viewModel.actionItem(index: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = action.rawValue
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        return cell
    }
}
