//
//  SettingsManager + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 02.07.2023.
//

import UIKit

// MARK: - SettingsManagerProtocol
extension SettingsManager: SettingsManagerProtocol {
   
    // MARK: - Action To Recall
    func checkShakeToRecallOption()-> Bool {
        let option = UserDefaults.standard.value(forKey: "onShakeToRecall") as? Bool ?? true
        return option
    }
    
    // MARK: - Only Main
    func checkOnlyMainOption()-> OnlyMainVariants {
        let variant = UserDefaults.loadData(type: OnlyMainVariants.self, key: "variant") ?? .none
        return variant
    }
    
    func observeOnlyMainChangedOption(completion: @escaping()->Void) {
        NotificationCenter.default.addObserver(forName: Notification.Name("only main"), object: nil, queue: .main) { _ in
            completion()
        }
    }
    
    // MARK: - Advanced Timetable
    func checkSaveRecentTimetableItem()-> Bool {
        let option = UserDefaults.standard.value(forKey: "onSaveRecentTimetableItem") as? Bool ?? true
        return option
    }
    
    // MARK: - ASPU Button
    func checkCurrentIcon()-> String {
        let icon = UserDefaults.standard.object(forKey: "icon") as? String ?? "АГПУ"
        return icon
    }
    
    func checkASPUButtonOption()-> ASPUButtonActions {
        let action = UserDefaults.loadData(type: ASPUButtonActions.self, key: "action") ?? .speechRecognition
        return action
    }
    
    func observeASPUButtonActionChanged(completion: @escaping()->Void) {
        NotificationCenter.default.addObserver(forName: Notification.Name("action"), object: nil, queue: .main) { _ in
            completion()
        }
    }
    
    func checkASPUButtonAnimationOption()-> ASPUButtonAnimationOptions {
        let option = UserDefaults.loadData(type: ASPUButtonAnimationOptions.self, key: "animation") ?? .spring
        return option
    }
    
    // MARK: - Visual Changes
    func checkScreenPresentationStyleOption()-> ScreenPresentationStyles {
        let style = UserDefaults.loadData(type: ScreenPresentationStyles.self, key: "screen presentation style") ?? .notShow
        return style
    }

    // MARK: - My Splash Screen
    func saveCustomSplashScreen(screen: CustomSplashScreenModel) {
        realmManager.saveSplashScreen(screen: screen)
    }
    
    func getCustomSplashScreen()-> CustomSplashScreenModel {
        let screen = realmManager.getSplashScreen()
        return screen
    }
    
    func getSplashScreenBackgroundColor()-> BackgroundColors {
        let color = UserDefaults.loadData(type: BackgroundColors.self, key: "splash screen background color") ?? .system
        return color
    }
    
    // MARK: - Your Status
    func checkCurrentStatus()-> UIViewController {
        let status = UserDefaults.loadData(type: UserStatusModel.self, key: "user status")
        switch status?.id {
        case 1:
            let vc = ForApplicantListTableViewController()
            vc.tabBarItem = UITabBarItem(title: "Абитуриенту", image: getTabIconForStatus().icon, selectedImage: getTabIconForStatus().selectedIcon)
            let navVC = UINavigationController(rootViewController: vc)
            return navVC
        case 2:
            let vc = ForStudentListTableViewController()
            vc.tabBarItem = UITabBarItem(title: "Студенту", image:  getTabIconForStatus().icon, selectedImage: getTabIconForStatus().selectedIcon)
            let navVC = UINavigationController(rootViewController: vc)
            return navVC
        case 3:
            let vc = ForEmployeeListTableViewController()
            vc.tabBarItem = UITabBarItem(title: "Сотруднику", image: getTabIconForStatus().icon, selectedImage: getTabIconForStatus().selectedIcon)
            let navVC = UINavigationController(rootViewController: vc)
            return navVC
        default:
            let vc = ForApplicantListTableViewController()
            vc.tabBarItem = UITabBarItem(title: "Абитуриенту", image: getTabIconForStatus().icon, selectedImage: getTabIconForStatus().selectedIcon)
            let navVC = UINavigationController(rootViewController: vc)
            return navVC
        }
    }
    
    func getUserStatus()-> UserStatusModel {
        if let status = UserDefaults.loadData(type: UserStatusModel.self, key: "user status") {
            return status
        } else {
            return UserStatusList.list[0]
        }
    }
    
    func observeStatusChanged(completion: @escaping()->Void) {
        NotificationCenter.default.addObserver(forName: Notification.Name("user status"), object: nil, queue: .main) { _ in
            completion()
        }
    }
    
    // MARK: - Custom TabBar
    func getTabsPosition()-> [Int] {
        let position = UserDefaults.standard.object(forKey: "tabs") as? [Int] ?? [0,1,2,3]
        return position
    }
    
    func getTabsColor()-> TabColors {
        let color = UserDefaults.loadData(type: TabColors.self, key: "tabs color") ?? .system
        return color
    }
    
    func getTabsIconStyle()-> TabBarIconsStyle {
        let style = UserDefaults.loadData(type: TabBarIconsStyle.self, key: "tabs icon style") ?? .flatIcon
        return style
    }
    
    func getTabIconForStatus()-> TabBarIconModel {
        
        let status = UserDefaults.loadData(type: UserStatusModel.self, key: "user status")
        let style = getTabsIconStyle()
        
        switch style {
            
        case .flatIcon:
            
            if status?.id == 1 {
                return TabBarIconModel(icon: UIImage(named: "applicant")!, selectedIcon: UIImage(named: "applicant selected")!)
            } else if status?.id == 2 {
                return TabBarIconModel(icon: UIImage(named: "student icon")!, selectedIcon: UIImage(named: "student icon selected")!)
            } else if status?.id == 3 {
                return TabBarIconModel(icon: UIImage(named: "computer")!, selectedIcon: UIImage(named: "computer selected")!)
            }
        case .apple:
            if status?.id == 1 {
                return TabBarIconModel(icon: UIImage(systemName: "person")!, selectedIcon: UIImage(systemName: "person.fill")!)
            } else if status?.id == 2 {
                return TabBarIconModel(icon: UIImage(systemName: "graduationcap")!, selectedIcon: UIImage(systemName: "graduationcap.fill")!)
            } else if status?.id == 3 {
                return TabBarIconModel(icon: UIImage(systemName: "desktopcomputer")!, selectedIcon: UIImage(systemName: "desktopcomputer.fill")!)
            }
        }
        
        return style == .flatIcon ? TabBarIconModel(icon: UIImage(named: "applicant")!, selectedIcon: UIImage(named: "applicant selected")!) : TabBarIconModel(icon: UIImage(named: "person")!, selectedIcon: UIImage(named: "person.fill")!)
    }
    
    func getTabsIcons()-> [TabBarIconModel] {
        let style = getTabsIconStyle()
        switch style {
        case .flatIcon:
            let news = TabBarIconModel(icon: UIImage(named: "mail")!, selectedIcon: UIImage(named: "mail selected")!)
            let timetable = TabBarIconModel(icon: UIImage(named: "time icon")!, selectedIcon: UIImage(named: "time icon selected")!)
            let settings = TabBarIconModel(icon: UIImage(named: "settings")!, selectedIcon: UIImage(named: "settings selected")!)
            return [news, timetable, settings]
        case .apple:
            let news = TabBarIconModel(icon: UIImage(systemName: "newspaper")!, selectedIcon: UIImage(systemName: "newspaper.fill")!)
            let timetable = TabBarIconModel(icon: UIImage(systemName: "clock")!, selectedIcon: UIImage(systemName: "clock.fill")!)
            let settings = TabBarIconModel(icon: UIImage(systemName: "gearshape")!, selectedIcon: UIImage(systemName: "gearshape.fill")!)
            return [news, timetable, settings]
        }
    }
    
    func checkTabsAnimationOption()-> Bool {
        let option = UserDefaults.standard.object(forKey: "onTabsAnimation") as? Bool ?? true
        return option
    }
    
    func observeTabsChanged(completion: @escaping()->Void) {
        NotificationCenter.default.addObserver(forName: Notification.Name("tabs changed"), object: nil, queue: .main) { _ in
            completion()
        }
    }
}
