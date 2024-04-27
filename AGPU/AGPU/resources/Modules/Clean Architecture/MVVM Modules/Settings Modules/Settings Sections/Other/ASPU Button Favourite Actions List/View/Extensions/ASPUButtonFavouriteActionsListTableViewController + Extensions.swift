//
//  ASPUButtonFavouriteActionsListTableViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 27.04.2024.
//

import UIKit

// MARK: - ASPUButtonAllActionsListTableViewControllerDelegate
extension ASPUButtonFavouriteActionsListTableViewController: ASPUButtonAllActionsListTableViewControllerDelegate {
    
    func actionWasAdded() {
        viewModel.getActions()
    }
}
