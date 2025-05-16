//
//  SceneDelegate.swift
//  AGPU
//
//  Created by Марк Киричко on 08.06.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = setUpSplashScreen()
        window.overrideUserInterfaceStyle = UserDefaults.loadData(type: AppThemeModel.self, key: "theme")?.theme ?? .dark
        window.makeKeyAndVisible()
        self.window = window
        handleShortCut(window: window, shortcut: connectionOptions.shortcutItem)
    }
    
    private func handleShortCut(window: UIWindow, shortcut: UIApplicationShortcutItem?) {
        if let shortcutItem = shortcut {
            if let _ = window.rootViewController as? UIViewController {
                window.rootViewController = AGPUTabBarController()
                if let tabBarController = window.rootViewController as? AGPUTabBarController {
                    openScreen(tabBarController: tabBarController, title: shortcutItem.type)
                }
            } else {
                if let tabBarController = window.rootViewController as? AGPUTabBarController {
                    openScreen(tabBarController: tabBarController, title: shortcutItem.type)
                }
            }
        }
    }
    
    func openScreen(tabBarController: AGPUTabBarController, title: String) {
        print("НАЗВАНИЕ: \(title)")
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            if title == "building" {
                tabBarController.showNearestBuilding(isAction: true)
            } else if title == "maps" {
                tabBarController.openCampusMap()
            } else if title == "weeks" {
                tabBarController.openWeeksTimetable()
            } else if title == "calendar" {
                tabBarController.openCalendarVC()
            } else if title == "website sections" {
                tabBarController.openSectionsList()
            } else if title == "today news" {
                tabBarController.openWhatsNew()
            } else if title == "voice commands" {
                tabBarController.openVoiceCommands(isAction: true)
            } else if title == "app themes" {
                tabBarController.openAppThemes()
            } else if title == "app shortcuts" {
                tabBarController.openAppShortcuts()
            }
        }
    }
    
    private func setUpSplashScreen()-> UIViewController {
        let option = UserDefaults.loadData(type: SplashScreenOptions.self, key: "splash option") ?? .regular
        let regularVC = RegularSplashScreenViewController(animation:  AnimationClass(), icon: "АГПУ", text: "ФГБОУ ВО «АГПУ»", width: 180, height: 180)
        let facultyVC = SelectedFacultySplashScreenViewController(animation: AnimationClass())
        let newYearVC = RegularSplashScreenViewController(animation:  AnimationClass(), icon: "новый год", text: "ФГБОУ ВО «АГПУ»", width: 180, height: 180)
        let weatherVC = WeatherSplashScreenViewController(animation: AnimationClass())
        let newsVC = NewsSplashScreenViewController(animation: AnimationClass())
        let timetableVC = TimeTableSplashScreenViewController(animation: AnimationClass())
        let customVC = CustomSplashScreenViewController(animation: AnimationClass())
        let randomVC = RandomSplashScreenViewController()
        let tabBarVC = AGPUTabBarController()
        switch option {
        case .regular:
            return regularVC
        case .faculty:
            return facultyVC
        case .newyear:
            return newYearVC
        case .weather:
            return weatherVC
        case .news:
            return newsVC
        case .timetable:
            return timetableVC
        case .corps:
            return BuildingSplashScreenViewController(animation: AnimationClass())
        case .technopark:
            return RegularSplashScreenViewController(animation: AnimationClass(), icon: "technopark", text: "Технопарк", width: 180, height: 180)
        case .quantorium:
            return RegularSplashScreenViewController(animation: AnimationClass(), icon: "кванториум", text: "Кванториум", width: 160, height: 160)
        case .season:
            return SeasonSplashScreenViewController(animation: AnimationClass())
        case .halloween:
            return RegularSplashScreenViewController(animation: AnimationClass(), icon: "pumpkin", text: "Хэллоуин", width: 100, height: 100)
        case .custom:
            return customVC
        case .random:
            return randomVC
        case .none:
            return tabBarVC
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        UIApplication.shared.shortcutItems =
        loadShortcuts().map { UIApplicationShortcutItem(type: $0.id, localizedTitle: $0.title, localizedSubtitle: $0.subtitle, icon: UIApplicationShortcutIcon(templateImageName: $0.icon))}.reversed()
    }
    
    func loadShortcuts()-> [ShortcutModel] {
        var data = [ShortcutModel]()
        if let result = UserDefaults.standard.object(forKey: "shortcuts") as? Data {
            do {
                data = try JSONDecoder().decode([ShortcutModel].self, from: result)
            } catch {
                print(error)
            }
        }
        return data
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        handleShortCut(window: window!, shortcut: shortcutItem)
    }
}
