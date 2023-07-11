//
//  SettingsListViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 23.06.2023.
//

import UIKit

// MARK: - UITableViewDataSource
extension SettingsListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionsCount()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.cellForRowAt(tableView: tableView, indexPath: indexPath)
    }
}

// MARK: - UITableViewDelegate
extension SettingsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return viewModel.HeaderForView(in: section, view: self.view)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil,
                                          actionProvider: {
            _ in
           
            let playAction = UIAction(title: "воспроизвести", image: UIImage(named: "play")) { _ in
                self.viewModel.OnMusic(index: indexPath.row)
            }
            let pauseAction = UIAction(title: "пауза", image: UIImage(named: "pause")) { _ in
                self.viewModel.OffMusic(index: indexPath.row)
            }
            let restartAction = UIAction(title: "заново", image: UIImage(named: "restart")) { _ in
                self.viewModel.RestartMusic(index: indexPath.row)
            }
            let deleteAction = UIAction(title: "удалить", image: UIImage(named: "trash")) { _ in
                self.viewModel.DeleteMusic(index: indexPath.row)
            }
            return UIMenu(title: self.viewModel.musicItem(index: indexPath.row).name, children: [playAction, pauseAction, restartAction, deleteAction])
        })
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        switch indexPath.section {
        case 0:
            let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
                self.viewModel.DeleteMusic(index: indexPath.row)
            }
            deleteAction.image = UIImage(systemName: "trash")
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
            return configuration
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.DidSelectRow(at: indexPath)
    }
}
