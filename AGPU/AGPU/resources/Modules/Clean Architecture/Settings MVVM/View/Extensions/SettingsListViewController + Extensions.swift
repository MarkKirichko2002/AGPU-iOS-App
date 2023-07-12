//
//  SettingsListViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 23.06.2023.
//

import UIKit

// MARK: - UITableViewDataSource
extension SettingsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return AGPUFaculties.faculties.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AGPUFacultyTableViewCell.identifier, for: indexPath) as? AGPUFacultyTableViewCell else {return UITableViewCell()}
        cell.accessoryType = viewModel.isFacultySelected(index: indexPath.row)
        cell.tintColor = .systemGreen
        cell.configure(faculty: AGPUFaculties.faculties[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SettingsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "выберите факультет"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.ChangeFaculty(index: indexPath.row)
    }
}
