//
//  ASPUButtonActionsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 04.02.2024.
//

import UIKit

final class ASPUButtonActionsListTableViewController: UITableViewController {

    private let viewModel = ASPUButtonActionsListViewModel()
    
    var isOption = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        let titleView = CustomTitleView(image: "button", title: viewModel.titleForNavigation(), frame: .zero)
        if isOption {
            setUpCloseButton()
        } else {
            setUpBackButton()
        }
        navigationItem.titleView = titleView
    }
    
    func setUpCloseButton() {
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .done, target: self, action: #selector(close))
        closeButton.tintColor = .label
        navigationItem.rightBarButtonItem = closeButton
    }
    
    func setUpBackButton() {
        
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        let backButton = UIBarButtonItem(customView: button)
        
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func close() {
        HapticsManager.shared.hapticFeedback()
        dismiss(animated: true)
    }
    
    private func setUpTable() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func bindViewModel() {
        viewModel.registerDataSelectedHandler {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let action = viewModel.actionItem(index: indexPath.row)
        if action == .favourite {
            let vc = ASPUButtonFavouriteActionsListTableViewController()
            vc.isSettings = true
            navigationController?.pushViewController(vc, animated: true)
            viewModel.selectAction(index: indexPath.row)
            closeScreen()
        } else {
            viewModel.selectAction(index: indexPath.row)
            closeScreen()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func closeScreen() {
        if isOption {
            close()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.actionItemsCount()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.tintColor = .systemGreen
        cell.textLabel?.text = viewModel.actionItem(index: indexPath.row).rawValue
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        cell.textLabel?.textColor = viewModel.isActionSelected(index: indexPath.row) ? .systemGreen : .label
        cell.accessoryType = viewModel.isActionSelected(index: indexPath.row) ? .checkmark : .none
        return cell
    }
}
