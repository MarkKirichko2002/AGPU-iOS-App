//
//  SettingsListViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 23.06.2023.
//

import UIKit
import SafariServices

// MARK: - UITableViewDataSource
extension SettingsListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView)-> Int {
        return viewModel.sectionsCount()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)-> Int {
        viewModel.numberOfOptions(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectedFacultyOptionTableViewCell.identifier, for: indexPath) as? SelectedFacultyOptionTableViewCell else {return UITableViewCell()}
                let faculty = viewModel.getSelectedFacultyInfo()
                cell.configure(faculty: faculty)
                return cell
            } else if indexPath.row == 1 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: AdaptiveNewsOptionTableViewCell.identifier, for: indexPath) as? AdaptiveNewsOptionTableViewCell else {return UITableViewCell()}
                return cell
            } else if indexPath.row == 2 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: TimetableOptionTableViewCell.identifier, for: indexPath) as? TimetableOptionTableViewCell else {return UITableViewCell()}
                return cell
            }
        case 1:
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ActionToRecallOptionTableViewCell.identifier, for: indexPath) as? ActionToRecallOptionTableViewCell else {return UITableViewCell()}
                cell.delegate = self
                return cell
            } else if indexPath.row == 1 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: SayAnyWhereTableViewCell.identifier, for: indexPath) as? SayAnyWhereTableViewCell else {return UITableViewCell()}
                return cell
            } else if indexPath.row == 2 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ASPUButtonsScreenVariantsListTableViewCell.identifier, for: indexPath) as? ASPUButtonsScreenVariantsListTableViewCell else {return UITableViewCell()}
                return cell
            } else if indexPath.row == 3 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: GlanceInfoOptionTableViewCell.identifier, for: indexPath) as? GlanceInfoOptionTableViewCell else {return UITableViewCell()}
                return cell
            } else if indexPath.row == 4 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: SplashScreenOptionTableViewCell.identifier, for: indexPath) as? SplashScreenOptionTableViewCell else {return UITableViewCell()}
                cell.configure(name: viewModel.getSplashScreenInfo())
                return cell
            } else if indexPath.row == 5 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: AppIconTableViewCell.identifier, for: indexPath) as? AppIconTableViewCell else {return UITableViewCell()}
                cell.configure(icon: viewModel.getAppIconInfo())
                return cell
            } else if indexPath.row == 6 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTabBarOptionTableViewCell.identifier, for: indexPath) as? CustomTabBarOptionTableViewCell else {return UITableViewCell()}
                return cell
            } else if indexPath.row == 7 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: SettablePersonalityTableViewCell.identifier, for: indexPath) as? SettablePersonalityTableViewCell else {return UITableViewCell()}
                return cell
            } else if indexPath.row == 8 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ShortcutOptionTableViewCell.identifier, for: indexPath) as? ShortcutOptionTableViewCell else {return UITableViewCell()}
                return cell
            } else if indexPath.row == 9 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuOptionsOptionTableViewCell.identifier, for: indexPath) as? MenuOptionsOptionTableViewCell else {return UITableViewCell()}
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 25))
        header.backgroundColor = .systemBackground
        header.layer.borderWidth = 3
        header.layer.borderColor = UIColor.label.cgColor
        header.layer.cornerRadius = 10
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        header.addSubview(label)
        switch section {
        case 0:
            label.text = "Основное"
        case 1:
            label.text = "Другие опции"
        case 2:
            label.text = "О приложении (версия: \(viewModel.getAppVersion()))"
        default:
            label.text = ""
        }
        label.textColor = .label
        label.font = .systemFont(ofSize: 17, weight: .black)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: header.topAnchor, constant: 10),
            label.leftAnchor.constraint(equalTo: header.leftAnchor, constant: 20),
            label.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -10),
        ])
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                if let cell = tableView.cellForRow(at: indexPath) as? SelectedFacultyOptionTableViewCell {
                    cell.didTapCell(indexPath: indexPath) {
                        self.handleButton(icon: "university", vc: SelectedFacultyListTableViewController())
                    }
                }
            } else if indexPath.row == 1 {
                if let cell = tableView.cellForRow(at: indexPath) as? AdaptiveNewsOptionTableViewCell {
                    cell.didTapCell(indexPath: indexPath) {
                        let vc = AdaptiveNewsOptionsListTableViewController()
                        vc.isSettings = true
                        self.handleButton(icon: "news", vc: vc)
                    }
                }
            } else if indexPath.row == 2 {
                if let cell = tableView.cellForRow(at: indexPath) as? TimetableOptionTableViewCell {
                    cell.didTapCell(indexPath: indexPath) {
                        self.handleButton(icon: "clock", vc: TimetableFeaturesOptionsListTableViewController())
                    }
                }
            }
        case 1:
            if indexPath.row == 1 {
                if let cell = tableView.cellForRow(at: indexPath) as? SayAnyWhereTableViewCell {
                    cell.didTapCell(indexPath: indexPath) {
                        self.handleButton(icon: "microphone", vc: SpeechScreenVariantsListTableViewController())
                    }
                }
            } else if indexPath.row == 2 {
                if let cell = tableView.cellForRow(at: indexPath) as? ASPUButtonsScreenVariantsListTableViewCell {
                    cell.didTapCell(indexPath: indexPath) {
                        self.handleButton(icon: "button", vc: ASPUButtonsScreenVariantsListTableViewController())
                    }
                }
            } else if indexPath.row == 3 {
                if let cell = tableView.cellForRow(at: indexPath) as? GlanceInfoOptionTableViewCell {
                    cell.didTapCell(indexPath: indexPath) {
                        self.handleButton(icon: "eye", vc: GlanceInfoOptionsListTableViewController())
                    }
                }
            } else if indexPath.row == 4 {
                if let cell = tableView.cellForRow(at: indexPath) as? SplashScreenOptionTableViewCell {
                    cell.didTapCell(indexPath: indexPath) {
                        self.handleButton(icon: "mobile", vc: SplashScreensListTableViewController())
                    }
                }
            } else if indexPath.row == 5 {
                if let cell = tableView.cellForRow(at: indexPath) as? AppIconTableViewCell {
                    cell.didTapCell(indexPath: indexPath) {
                        self.handleButton(icon: "photo icon", vc: AppIconsListTableViewController())
                    }
                }
            } else if indexPath.row == 6 {
                if let cell = tableView.cellForRow(at: indexPath) as? CustomTabBarOptionTableViewCell {
                    cell.didTapCell(indexPath: indexPath) {
                        self.handleButton(icon: "profile icon", vc: OnlyMainVariantsListTableViewController())
                    }
                }
            } else if indexPath.row == 7 {
                if let cell = tableView.cellForRow(at: indexPath) as? SettablePersonalityTableViewCell {
                    cell.didTapCell(indexPath: indexPath) {
                        self.handleButton(icon: "gear", vc: SettablePersonalityOptionsListTableViewController())
                    }
                }
            } else if indexPath.row == 8 {
                if let cell = tableView.cellForRow(at: indexPath) as? ShortcutOptionTableViewCell {
                    cell.didTapCell(indexPath: indexPath) {
                        self.handleButton(icon: "sections icon", vc: FavouriteShortcutsListTableViewController())
                    }
                }
            } else if indexPath.row == 9 {
                if let cell = tableView.cellForRow(at: indexPath) as? MenuOptionsOptionTableViewCell {
                    cell.didTapCell(indexPath: indexPath) {
                        self.handleButton(icon: "sections icon", vc: MenuOptionCategoriesListTableViewController())
                    }
                }
            } else if indexPath.row == 10 {
                if let cell = tableView.cellForRow(at: indexPath) as? AppThemesTableViewCell {
                    cell.didTapCell(indexPath: indexPath) {
                        self.handleButton(icon: "theme", vc: AppThemesListTableViewController())
                    }
                }
            }
        case 2:
            if indexPath.row == 0 {
                if let cell = tableView.cellForRow(at: indexPath) as? AppFeaturesTableViewCell {
                    cell.didTapCell(indexPath: indexPath) {
                        self.handleButton(icon: "info icon", vc: AppFeaturesListTableViewController())
                    }
                }
            } else {
                HapticsManager.shared.hapticFeedback()
                let vc = SFSafariViewController(url: URL(string: "https://weatherkit.apple.com/legal-attribution.html")!)
                present(vc, animated: true)
            }
        default:
            break
        }
    }
    
    func handleButton(icon: String, vc: UIViewController) {
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true)
    }
}

// MARK: - ActionToRecallOptionTableViewCellDelegate
extension SettingsListViewController: ActionToRecallOptionTableViewCellDelegate {
    
    func iconWasTapped() {
        let vc = RecentMomentsListTableViewController()
        vc.isNotify = false
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            self.present(navVC, animated: true)
        }
    }
}

extension SettingsListViewController {
    
    func openNewsSettings() {
        let vc = AdaptiveNewsOptionsListTableViewController()
        vc.modalPresentationStyle = .fullScreen
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
    
    func openTimetableSettings() {
        let vc = TimetableFeaturesOptionsListTableViewController()
        vc.modalPresentationStyle = .fullScreen
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
    
    func openTabBarSettings() {
        let vc = OnlyMainVariantsListTableViewController()
        vc.modalPresentationStyle = .fullScreen
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
    
    func openAppThemes() {
        let vc = AppThemesListTableViewController()
        vc.modalPresentationStyle = .fullScreen
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
    
    func openASPUButtonSettings() {
        let vc = ASPUButtonOptionsListTableViewController()
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
    
    func openAppShortcuts() {
        let vc = FavouriteShortcutsListTableViewController()
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
}
