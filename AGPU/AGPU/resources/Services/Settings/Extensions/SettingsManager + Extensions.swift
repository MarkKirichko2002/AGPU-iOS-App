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
        if let option = UserDefaults.standard.value(forKey: "onSaveRecentTimetableItem") as? Bool {
            return option
        } else {
            return false
        }
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
            vc.tabBarItem = UITabBarItem(title: "Абитуриенту", image: UIImage(named: "applicant"), selectedImage: UIImage(named: "applicant selected"))
            let navVC = UINavigationController(rootViewController: vc)
            return navVC
        case 2:
            let vc = ForStudentListTableViewController()
            vc.tabBarItem = UITabBarItem(title: "Студенту", image: UIImage(named: "student icon"), selectedImage: UIImage(named: "student icon selected"))
            let navVC = UINavigationController(rootViewController: vc)
            return navVC
        case 3:
            let vc = ForEmployeeListTableViewController()
            vc.tabBarItem = UITabBarItem(title: "Сотруднику", image: UIImage(named: "computer"), selectedImage: UIImage(named: "computer selected"))
            let navVC = UINavigationController(rootViewController: vc)
            return navVC
        default:
            let vc = ForApplicantListTableViewController()
            vc.tabBarItem = UITabBarItem(title: "Абитуриенту", image: UIImage(named: "applicant"), selectedImage: UIImage(named: "applicant selected"))
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
