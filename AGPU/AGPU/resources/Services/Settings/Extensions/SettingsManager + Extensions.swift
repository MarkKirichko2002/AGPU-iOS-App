//
//  SettingsManager + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 02.07.2023.
//

import UIKit

// MARK: - SettingsManagerProtocol
extension SettingsManager: SettingsManagerProtocol {
   
    // MARK: - Your Status
    func observeStatusChanged(completion: @escaping()->Void) {
        NotificationCenter.default.addObserver(forName: Notification.Name("user status"), object: nil, queue: .main) { notification in
            if let _ = notification.object as? UserStatusModel {
                completion()
            }
        }
    }
    
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
    
    // MARK: - Selected Faculty
    func checkCurrentIcon()-> String {
        let icon = UserDefaults.standard.object(forKey: "icon") as? String ?? "АГПУ"
        return icon
    }
    
    // MARK: - Shake To Recall
    func checkShakeToRecallOption()-> Bool {
        if let option = UserDefaults.standard.value(forKey: "onShakeToRecallOption") as? Bool {
            return option
        } else {
            return false
        }
    }
    
    // MARK: - Only Timetable
    func checkOnlyTimetableOption()-> Bool {
        if let option = UserDefaults.standard.value(forKey: "onOnlyTimetable") as? Bool {
            return option
        } else {
            return false
        }
    }
    
    func observeOnlyTimetableChanged(completion: @escaping()->Void) {
        NotificationCenter.default.addObserver(forName: Notification.Name("only timetable"), object: nil, queue: .main) { _ in
            completion()
        }
    }
}
