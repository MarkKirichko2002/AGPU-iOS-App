//
//  SimpleModeTabBarController.swift
//  AGPU
//
//  Created by Марк Киричко on 15.09.2024.
//

import UIKit

final class SimpleModeTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabs()
    }
    
    private func setUpTabs() {
        let newsListVC = UINavigationController(rootViewController: NewsListViewController())
        newsListVC.tabBarItem = UITabBarItem(title: "Новости", image: UIImage(named: "mail"), selectedImage: UIImage(named: "mail selected"))
        let timetableVC = UINavigationController(rootViewController: TimeTableContainerViewController())
        timetableVC.tabBarItem = UITabBarItem(title: "Расписание", image: UIImage(named: "time icon"), selectedImage: UIImage(named: "time icon selected"))
        let mapVC = UINavigationController(rootViewController: SimpleMapViewController())
        mapVC.tabBarItem = UITabBarItem(title: "Карты", image: UIImage(named: "map"), selectedImage: UIImage(named: "map selected"))
        let settingsVC = UINavigationController(rootViewController: SimpleSettingsViewController())
        settingsVC.tabBarItem = UITabBarItem(title: "Настройки", image: UIImage(named: "settings"), selectedImage: UIImage(named: "settings selected"))
        UITabBar.appearance().tintColor = .label
        view.backgroundColor = .systemBackground
        UITabBar.appearance().backgroundColor = .systemBackground
        setViewControllers([newsListVC, timetableVC, mapVC, settingsVC], animated: false)
    }
    
    // MARK: - Action To Control
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        showReturnAlert()
    }
    
    func showReturnAlert() {
        let yes = UIAlertAction(title: "Да", style: .default) { _ in
            self.goBackToAdvancedMode()
        }
        let cancel = UIAlertAction(title: "Нет", style: .destructive)
        self.showAlert(title: "Вернуться обратно?", message: "хотите вернуться в продвинутый режим?", actions: [yes, cancel])
    }
}
