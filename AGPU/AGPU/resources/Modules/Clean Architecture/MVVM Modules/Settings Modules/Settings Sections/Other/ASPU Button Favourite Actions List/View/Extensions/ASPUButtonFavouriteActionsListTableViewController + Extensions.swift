//
//  ASPUButtonFavouriteActionsListTableViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 27.04.2024.
//

import UIKit

// MARK: - UITableViewDelegate
extension ASPUButtonFavouriteActionsListTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let action = viewModel.actionItem(index: indexPath.row)
            viewModel.deleteAction(action: action)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let action = viewModel.actionItem(index: indexPath.row)
        if !isSettings {
            delegate?.actionWasSelected(action: action)
            HapticsManager.shared.hapticFeedback()
            dismiss(animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension ASPUButtonFavouriteActionsListTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.actionsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let action = viewModel.actionItem(index: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = action.rawValue
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        return cell
    }
}

// MARK: - ASPUButtonAllActionsListTableViewControllerDelegate
extension ASPUButtonFavouriteActionsListTableViewController: ASPUButtonAllActionsListTableViewControllerDelegate {
    
    func actionWasAdded() {
        viewModel.getActions()
    }
}
