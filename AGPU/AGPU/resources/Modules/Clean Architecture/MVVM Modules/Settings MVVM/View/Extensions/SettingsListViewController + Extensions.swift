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
        switch section {
        case 0:
            return UserStatusList.list.count
        case 1:
            return AGPUFaculties.faculties.count
        case 2:
            return 1
        case 3:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.accessoryType = viewModel.isStatusSelected(index: indexPath.row) ? .checkmark : .none
            cell.tintColor = .systemGreen
            cell.textLabel?.text = UserStatusList.list[indexPath.row].name
            cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
            cell.textLabel?.textColor = viewModel.isStatusSelected(index: indexPath.row) ? .systemGreen : .black
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AGPUFacultyTableViewCell.identifier, for: indexPath) as? AGPUFacultyTableViewCell else {return UITableViewCell()}
            cell.accessoryType = viewModel.isFacultySelected(index: indexPath.row) ? .checkmark : .none
            cell.tintColor = .systemGreen
            cell.AGPUFacultyName.textColor = viewModel.isFacultySelected(index: indexPath.row) ? .systemGreen : .black
            cell.configure(faculty: AGPUFaculties.faculties[indexPath.row])
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ShakeToRecallOptionTableViewCell.identifier, for: indexPath) as? ShakeToRecallOptionTableViewCell else {return UITableViewCell()}
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AppFeaturesTableViewCell.identifier, for: indexPath) as? AppFeaturesTableViewCell else {return UITableViewCell()}
            return cell
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - UITableViewDelegate
extension SettingsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Ваш Статус"
        case 1:
            return "Избранный Факультет"
        case 2:
            return "Shake To Recall"
        case 3:
            return "О приложение"
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
                
            case 1:
                
                let chooseFacultyAction = UIAction(title: self.viewModel.isFacultySelected(index: indexPath.row) ? "выбран факультет" : "выбрать факультет", image: self.viewModel.isFacultySelected(index: indexPath.row) ? UIImage(named: "check") : nil) { action in
                    self.viewModel.ChooseFaculty(index: indexPath.row)
                }
                                
                let chooseIconAction = UIAction(title: self.viewModel.isFacultyIconSelected(index: indexPath.row) ? "выбрана иконка" : "выбрать иконку", image: self.viewModel.isFacultyIconSelected(index: indexPath.row) ? UIImage(named: "check") : nil) { action in
                    if self.viewModel.isFacultySelected(index: indexPath.row) {
                        self.viewModel.ChooseFacultyIcon(index: indexPath.row)
                    } else {
                        NotificationCenter.default.post(name: Notification.Name("group"), object: nil)
                        let ok = UIAlertAction(title: "ОК", style: .default)
                        self.ShowAlert(title: "\(self.viewModel.facultyItem(index: indexPath.row).abbreviation) не ваш факультет!", message: "Вы не можете выбрать иконку факультета \(self.viewModel.facultyItem(index: indexPath.row).abbreviation) поскольку не относитесь к нему.", actions: [ok])
                    }
                }
                
                let cathedraAction = UIAction(title: self.viewModel.isCathedraSelected(index: indexPath.row) ? "выбрана кафедра" : "\(!self.viewModel.facultyItem(index: indexPath.row).cathedra.isEmpty ? "выбрать кафедру" : "кафедры отсутствуют")", image: self.viewModel.isCathedraSelected(index: indexPath.row) ? UIImage(named: "check") : nil) { action in
                    if self.viewModel.isFacultySelected(index: indexPath.row) && !self.viewModel.facultyItem(index: indexPath.row).cathedra.isEmpty {
                        let vc = FacultyCathedraListTableViewController(faculty: self.viewModel.facultyItem(index: indexPath.row))
                        vc.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else if self.viewModel.isFacultySelected(index: indexPath.row) &&  self.viewModel.facultyItem(index: indexPath.row).cathedra.isEmpty {
                        let ok = UIAlertAction(title: "ОК", style: .default)
                        self.ShowAlert(title: "У \(self.viewModel.facultyItem(index: indexPath.row).abbreviation) отсутствуют кафедры", message: "", actions: [ok])
                    } else {
                        NotificationCenter.default.post(name: Notification.Name("group"), object: nil)
                        let ok = UIAlertAction(title: "ОК", style: .default)
                        self.ShowAlert(title: "\(self.viewModel.facultyItem(index: indexPath.row).abbreviation) не ваш факультет!", message: "Вы не можете выбрать кафедру факультета \(self.viewModel.facultyItem(index: indexPath.row).abbreviation) поскольку не относитесь к нему.", actions: [ok])
                    }
                }
                
                let checkGroupAction = UIAction(title: self.viewModel.isGroupSelected(index: indexPath.row) ? "выбрана группа" : "выбрать группу", image: self.viewModel.isGroupSelected(index: indexPath.row) ? UIImage(named: "check") : nil) { _ in
                    if self.viewModel.isFacultySelected(index: indexPath.row) {
                        let vc = FacultyGroupsListTableViewController(faculty: self.viewModel.facultyItem(index: indexPath.row))
                        vc.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        NotificationCenter.default.post(name: Notification.Name("group"), object: nil)
                        let ok = UIAlertAction(title: "ОК", style: .default)
                        self.ShowAlert(title: "\(self.viewModel.facultyItem(index: indexPath.row).abbreviation) не ваш факультет!", message: "Вы не можете выбрать группу факультета \(self.viewModel.facultyItem(index: indexPath.row).abbreviation) поскольку не относитесь к нему.", actions: [ok])
                    }
                }
                
                let checkSubGroupAction = UIAction(title: self.viewModel.isSubGroupSelected(index: indexPath.row) ? "выбрана подгруппа" : "выбрать подгруппу", image: self.viewModel.isSubGroupSelected(index: indexPath.row) ? UIImage(named: "check") : nil) { _ in
                    if self.viewModel.isFacultySelected(index: indexPath.row) {
                        let vc = SubGroupsListTableViewController()
                        vc.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        NotificationCenter.default.post(name: Notification.Name("group"), object: nil)
                        let ok = UIAlertAction(title: "ОК", style: .default)
                        self.ShowAlert(title: "\(self.viewModel.facultyItem(index: indexPath.row).abbreviation) не ваш факультет!", message: "Вы не можете выбрать подгруппу факультета \(self.viewModel.facultyItem(index: indexPath.row).abbreviation) поскольку не относитесь к нему.", actions: [ok])
                    }
                }
                
                let cancelIconAction = UIAction(title: "отменить иконку", image: self.viewModel.isFacultySelected(index: indexPath.row) ? UIImage(named: "cancel") : nil) { action in
                    if self.viewModel.isFacultySelected(index: indexPath.row) {
                        self.viewModel.CancelFacultyIcon(index: indexPath.row)
                    } else {}
                }
                
                let cancelFacultyAction = UIAction(title: "отменить факультет", image: self.viewModel.isFacultySelected(index: indexPath.row) ? UIImage(named: "cancel") : nil) { _ in
                    self.viewModel.CancelFaculty(index: indexPath.row)
                }
                
                return UIMenu(title: self.viewModel.facultyItem(index: indexPath.row).name, children: [
                    chooseFacultyAction,
                    chooseIconAction,
                    cathedraAction,
                    checkGroupAction,
                    checkSubGroupAction,
                    cancelIconAction,
                    cancelFacultyAction
                ])
                
            default:
                return nil
                
            }
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            viewModel.ChooseStatus(index: indexPath.row)
        case 1,2:
            break
        case 3:
            NotificationCenter.default.post(name: Notification.Name("for student selected"), object: "info icon")
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
                let vc = AppFeaturesListTableViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        default:
            break
        }
    }
}
