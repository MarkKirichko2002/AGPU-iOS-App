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
            return "Избранный Факультет"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil,
                                          actionProvider: {
            _ in
            
            switch indexPath.section {
                
            case 0:
                
                let chooseAction = UIAction(title: "выбрать факультет", image: UIImage(named: "check")) { _ in
                    self.viewModel.ChooseFaculty(index: indexPath.row)
                }
                
                let checkGroupAction = UIAction(title: "выбрать группу", image: UIImage(named: self.viewModel.facultyItem(index: indexPath.row).icon)) { _ in
                    let vc = FacultyGroupsListTableViewController(faculty: self.viewModel.facultyItem(index: indexPath.row))
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
                let cancelAction = UIAction(title: "отмена", image: UIImage(named: "cancel")) { _ in
                    self.viewModel.CancelFaculty(index: indexPath.row)
                }
                
                return UIMenu(title: self.viewModel.facultyItem(index: indexPath.row).name, children: [chooseAction, checkGroupAction, cancelAction])
                
            default:
                return nil
                
            }
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
