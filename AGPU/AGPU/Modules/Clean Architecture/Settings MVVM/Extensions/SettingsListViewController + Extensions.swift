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
        return viewModel.musicListCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.accessoryType = viewModel.isMusicSelected(index: indexPath.row)
        cell.textLabel?.text = "\(viewModel.musicItem(index: indexPath.row).id)) \(viewModel.musicItem(index: indexPath.row).name)"
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SettingsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil,
                                          actionProvider: {
            suggestedActions in
            let playAction =
            UIAction(title: "воспроизвести",
                     image: UIImage(named: "play")) { action in
                self.viewModel.ToggleMusic(index: indexPath.row, isChecked: true)
            }
            let stopAction =
            UIAction(title: "пауза",
                     image: UIImage(named: "pause")) { action in
                self.viewModel.ToggleMusic(index: indexPath.row, isChecked: false)
            }
            return UIMenu(title: self.viewModel.musicItem(index: indexPath.row).name, children: [playAction, stopAction])
        })
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.titleForSection(section)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
