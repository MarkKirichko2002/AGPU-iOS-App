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
        window.overrideUserInterfaceStyle = UserDefaults.loadData(type: AppThemeModel.self, key: "theme")?.theme ?? .light
        window.makeKeyAndVisible()
        self.window = window
    }
    
    private func setUpSplashScreen()-> UIViewController {
        let option = UserDefaults.loadData(type: SplashScreenOptions.self, key: "splash option") ?? .regular
        let regularVC = RegularSplashScreenViewController(animation:  AnimationClass(), icon: "АГПУ", text: "ФГБОУ ВО «АГПУ»", width: 180, height: 180)
        let statusVC = YourStatusSplashScreenViewController(animation: AnimationClass())
        let facultyVC = SelectedFacultySplashScreenViewController(animation: AnimationClass())
        let newYearVC = RegularSplashScreenViewController(animation:  AnimationClass(), icon: "новый год", text: "ФГБОУ ВО «АГПУ»", width: 180, height: 180)
        let weatherVC = WeatherSplashScreenViewController(animation: AnimationClass())
        let newsVC = NewsSplashScreenViewController(animation: AnimationClass())
        let timetableVC = TimeTableSplashScreenViewController(animation: AnimationClass())
        let customVC = CustomSplashScreenViewController(animation: AnimationClass())
        let tabBarVC = AGPUTabBarController()
        switch option {
        case .regular:
            return regularVC
        case .status:
            return statusVC
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
        case .technopark:
            return RegularSplashScreenViewController(animation:  AnimationClass(), icon: "technopark", text: "Технопарк", width: 180, height: 180)
        case .quantorium:
            return RegularSplashScreenViewController(animation:  AnimationClass(), icon: "кванториум", text: "Кванториум", width: 160, height: 160)
        case .custom:
            return customVC
        case .random:
            return [regularVC, statusVC, facultyVC, newYearVC, weatherVC, newsVC, timetableVC,  customVC].randomElement()!
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
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
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
}
