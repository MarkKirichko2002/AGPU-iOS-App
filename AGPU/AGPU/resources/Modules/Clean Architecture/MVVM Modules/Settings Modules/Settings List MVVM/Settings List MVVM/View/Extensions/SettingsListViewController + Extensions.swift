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
            return 4
        case 1:
            return 3
        case 2:
            return 2
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: YourStatusOptionTableViewCell.identifier, for: indexPath) as? YourStatusOptionTableViewCell else {return UITableViewCell()}
                cell.configure(status: viewModel.getStatusInfo())
                return cell
            } else if indexPath.row == 1 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectedFacultyOptionTableViewCell.identifier, for: indexPath) as? SelectedFacultyOptionTableViewCell else {return UITableViewCell()}
                let faculty = viewModel.getSelectedFacultyInfo()
                cell.configure(faculty: faculty)
                return cell
            } else if indexPath.row == 2 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: AdaptiveNewsOptionTableViewCell.identifier, for: indexPath) as? AdaptiveNewsOptionTableViewCell else {return UITableViewCell()}
                cell.configure(category: viewModel.getSavedNewsCategoryInfo())
                return cell
            } else if indexPath.row == 3 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: TimetableOptionTableViewCell.identifier, for: indexPath) as? TimetableOptionTableViewCell else {return UITableViewCell()}
                return cell
            }
        case 1:
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ShakeToRecallOptionTableViewCell.identifier, for: indexPath) as? ShakeToRecallOptionTableViewCell else {return UITableViewCell()}
                return cell
            } else if indexPath.row == 1 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: AppIconTableViewCell.identifier, for: indexPath) as? AppIconTableViewCell else {return UITableViewCell()}
                cell.configure(icon: viewModel.getAppIconInfo())
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: AppThemesTableViewCell.identifier, for: indexPath) as? AppThemesTableViewCell else {return UITableViewCell()}
                cell.configure(theme: viewModel.getAppThemeInfo())
                return cell
            }
        case 2:
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: AppFeaturesTableViewCell.identifier, for: indexPath) as? AppFeaturesTableViewCell else {return UITableViewCell()}
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                cell.textLabel?.text = " Weather - Источник данных о погоде"
                cell.textLabel?.textAlignment = .center
                return cell
            }
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension SettingsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Основное"
        case 1:
            return "Другие опции"
        case 2:
            return "О приложение (версия: \(viewModel.getAppVersion()))"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                NotificationCenter.default.post(name: Notification.Name("for every status selected"), object: "profile icon")
                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                    let vc = UserStatusListTableViewController()
                    let navVC = UINavigationController(rootViewController: vc)
                    navVC.modalPresentationStyle = .fullScreen
                    self.present(navVC, animated: true)
                }
            } else if indexPath.row == 1 {
                NotificationCenter.default.post(name: Notification.Name("for every status selected"), object: "university")
                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                    let vc = SelectedFacultyListTableViewController()
                    let navVC = UINavigationController(rootViewController: vc)
                    navVC.modalPresentationStyle = .fullScreen
                    self.present(navVC, animated: true)
                }
            } else if indexPath.row == 2 {
                NotificationCenter.default.post(name: Notification.Name("for every status selected"), object: "news")
                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                    let vc = SavedNewsCategoryTableViewController()
                    let navVC = UINavigationController(rootViewController: vc)
                    navVC.modalPresentationStyle = .fullScreen
                    self.present(navVC, animated: true)
                }
            } else if indexPath.row == 3 {
                NotificationCenter.default.post(name: Notification.Name("for every status selected"), object: "timetable")
                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                    let vc = TimetableOptionsTableViewController()
                    let navVC = UINavigationController(rootViewController: vc)
                    navVC.modalPresentationStyle = .fullScreen
                    self.present(navVC, animated: true)
                }
            }
        case 1:
            if indexPath.row == 1 {
                NotificationCenter.default.post(name: Notification.Name("for every status selected"), object: "photo icon")
                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                    let vc = AppIconsListTableViewController()
                    let navVC = UINavigationController(rootViewController: vc)
                    navVC.modalPresentationStyle = .fullScreen
                    self.present(navVC, animated: true)
                }
            } else if indexPath.row == 2 {
                NotificationCenter.default.post(name: Notification.Name("for every status selected"), object: "theme")
                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                    let vc = AppThemesListTableViewController()
                    let navVC = UINavigationController(rootViewController: vc)
                    navVC.modalPresentationStyle = .fullScreen
                    self.present(navVC, animated: true)
                }
            }
        case 2:
            if indexPath.row == 0 {
                NotificationCenter.default.post(name: Notification.Name("for every status selected"), object: "info icon")
                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                    let vc = AppFeaturesListTableViewController()
                    let navVC = UINavigationController(rootViewController: vc)
                    navVC.modalPresentationStyle = .fullScreen
                    self.present(navVC, animated: true)
                }
            } else {
                HapticsManager.shared.hapticFeedback()
                self.goToWeb(url: "https://developer.apple.com/weatherkit/data-source-attribution/", image: "info", title: " Weather", isSheet: false)
            }
        default:
            break
        }
    }
}
