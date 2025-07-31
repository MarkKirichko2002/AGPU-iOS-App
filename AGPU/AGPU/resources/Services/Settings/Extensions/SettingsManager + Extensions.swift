//
//  SettingsManager + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 02.07.2023.
//

import UIKit
import MapKit

// MARK: - SettingsManagerProtocol
extension SettingsManager: SettingsManagerProtocol {
   
    func getSavedID()-> String {
        return UserDefaults.standard.object(forKey: "group") as? String ?? "ВМ-ИВТ-3-1"
    }
    
    func getSavedSubgroup()-> Int {
        return UserDefaults.standard.object(forKey: "subgroup") as? Int ?? 0
    }
    
    func getSavedOwner()-> String {
        return UserDefaults.standard.object(forKey: "recentOwner") as? String ?? "GROUP"
    }
    
    // MARK: - Say Anywhere
    func loadSpeechScreens()-> [SpeechScreens] {
        var data = [SpeechScreens]()
        if let result = UserDefaults.standard.object(forKey: "speech screens") as? Data {
            do {
                data = try JSONDecoder().decode([SpeechScreens].self, from: result)
            } catch {
                print(error)
            }
        }
        return data
    }
    
    // MARK: - Action To Control
    func checkActionToControlOption()-> Bool {
        let option = UserDefaults.standard.value(forKey: "onActionToControl") as? Bool ?? true
        return option
    }
    
    // MARK: - Only Main
    func checkOnlyMainOption()-> OnlyMainVariants {
        let variant = UserDefaults.loadData(type: OnlyMainVariants.self, key: "variant") ?? .main
        return variant
    }
    
    func observeOnlyMainChangedOption(completion: @escaping()->Void) {
        NotificationCenter.default.addObserver(forName: Notification.Name("only main"), object: nil, queue: .main) { _ in
            completion()
        }
    }
    
    // MARK: - Grounbreaking Timetable
    func checkSaveRecentTimetableItem()-> Bool {
        return UserDefaults.standard.value(forKey: "onSaveRecentTimetableItem") as? Bool ?? true
    }
    
    func checkDeviceOrientationControl()-> Bool {
        return UserDefaults.standard.object(forKey: "onDeviceOrientationContol timetable") as? Bool ?? false
    }
    
    func checkVolumeControl()-> Bool {
        return UserDefaults.standard.object(forKey: "onVolumeContol timetable") as? Bool ?? false
    }
    
    func checkRecordingVideo()-> Bool {
        return UserDefaults.standard.object(forKey: "onGestureButton timetable") as? Bool ?? false
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
    
    func checkASPUButtonGestureOption()-> ASPUButtonGestureOptions {
        let option = UserDefaults.loadData(type: ASPUButtonGestureOptions.self, key: "gesture") ?? .tap
        return option
    }
    
    func loadASPUButtonScreens()-> [ASPUButtonScreens] {
        var data = [ASPUButtonScreens]()
        if let result = UserDefaults.standard.object(forKey: "aspu button screens") as? Data {
            do {
                data = try JSONDecoder().decode([ASPUButtonScreens].self, from: result)
            } catch {
                print(error)
            }
        }
        return data
    }
    
    func saveASPUButtonTime(title: String, time: Int) {
        UserDefaults.standard.set(time, forKey: "aspu button \(title) time")
    }
    
    func loadASPUButtonTime(title: String)-> Int {
        return UserDefaults.standard.object(forKey: "aspu button \(title) time") as? Int ?? 0
    }
    
    // MARK: - Glance Info
    func checkScreenPresentationStyleOption()-> ScreenPresentationStyles {
        let style = UserDefaults.loadData(type: ScreenPresentationStyles.self, key: "screen presentation style") ?? .notShow
        return style
    }
    
    func getSavedDate(screen: String)-> String {
        let date = UserDefaults.standard.object(forKey: "saved date \(screen)") as? String ?? ""
        return date
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
    
    // MARK: - Your TabBar
    func getTabs()-> [TabModel] {
        var data = TabsList.tabs
        if let result = UserDefaults.standard.object(forKey: "tabs") as? Data {
            do {
                data = try JSONDecoder().decode([TabModel].self, from: result)
            } catch {
                print(error)
            }
        }
        return data
    }
    
    func getAdditionalTabVariant()-> AdditionalTabVariants {
        let variant = UserDefaults.loadData(type: AdditionalTabVariants.self, key: "additional tab") ?? .button
        return variant
    }
    
    func saveAdditionalTabName(variant: AdditionalTabVariants, title: String) {
        UserDefaults.standard.set(title, forKey: "\(variant.rawValue) title")
    }
    
    func getAdditionalTabName(title: String)-> String {
        let title = UserDefaults.standard.object(forKey: "\(title) title") as? String ?? ""
        return title
    }
    
    func getAdditionalTab()-> UIViewController {
        let variant = getAdditionalTabVariant()
        let icons = getTabsIcons()
        let name = getAdditionalTabName(title: variant.rawValue)
        let title = !name.isEmpty ? name : variant.rawValue
        switch variant {
        case .button:
            return UIViewController()
        case .weeksList:
            let vc = AllWeeksListTableViewController(id: getSavedID(), subgroup: getSavedSubgroup(), owner: getSavedOwner())
            vc.tabBarItem = UITabBarItem(title: title, image: icons[6].icon, selectedImage: icons[6].selectedIcon)
            vc.isTab = true
            let navVC = UINavigationController(rootViewController: vc)
            return navVC
        case .webSections:
            let vc = ASPUWebsiteSectionsListViewController()
            vc.tabBarItem = UITabBarItem(title: title, image: icons[5].icon, selectedImage: icons[5].selectedIcon)
            vc.isMain = true
            let navVC = UINavigationController(rootViewController: vc)
            return navVC
        case .maps:
            let vc = AGPUBuildingsMapViewController()
            vc.tabBarItem = UITabBarItem(title: title, image: icons[3].icon, selectedImage: icons[3].selectedIcon)
            vc.isTab = true
            let navVC = UINavigationController(rootViewController: vc)
            return navVC
        case .weather:
            let annotation = MKPointAnnotation()
            annotation.title = "Армавир"
            annotation.coordinate = CLLocationCoordinate2D(latitude: 44.9892, longitude: 41.1234)
            let vc = LocationWeatherDetailViewController(annotation: annotation)
            vc.tabBarItem = UITabBarItem(title: title, image: icons[7].icon, selectedImage: icons[7].selectedIcon)
            vc.isTab = true
            let navVC = UINavigationController(rootViewController: vc)
            return navVC
        case .building:
            let vc = NearBuildingViewController(info: .map)
            vc.tabBarItem = UITabBarItem(title: title, image: icons[8].icon, selectedImage: icons[8].selectedIcon)
            vc.isTab = true
            vc.modalPresentationStyle = .fullScreen
            return vc
        case .none:
            return UIViewController()
        }
    }
    
    func getTabsColor()-> TabColors {
        let color = UserDefaults.loadData(type: TabColors.self, key: "tabs color") ?? .system
        return color
    }
    
    func getTabsFont()-> TabFonts {
        let font = UserDefaults.loadData(type: TabFonts.self, key: "font") ?? .none
        return font
    }
    
    func getTabsIconStyle()-> TabBarIconsStyle {
        let style = UserDefaults.loadData(type: TabBarIconsStyle.self, key: "tabs icon style") ?? .flatIcon
        return style
    }
    
    func getTabsSoundsOption()-> TabBarSoundOptions {
        let option = UserDefaults.loadData(type: TabBarSoundOptions.self, key: "tabs sounds option") ?? .none
        return option
    }
    
    func getTabsIcons()-> [TabBarIconModel] {
        let style = getTabsIconStyle()
        switch style {
        case .flatIcon:
            let news = TabBarIconModel(icon: UIImage(named: "mail")!, selectedIcon: UIImage(named: "mail selected")!)
            let favourites = TabBarIconModel(icon: UIImage(named: "sections")!, selectedIcon: UIImage(named: "sections")!)
            let timetable = TabBarIconModel(icon: UIImage(named: "time icon")!, selectedIcon: UIImage(named: "time icon selected")!)
            let maps = TabBarIconModel(icon: UIImage(named: "map")!, selectedIcon: UIImage(named: "map selected")!)
            let settings = TabBarIconModel(icon: UIImage(named: "settings")!, selectedIcon: UIImage(named: "settings selected")!)
            let sections = TabBarIconModel(icon: UIImage(named: "globe")!, selectedIcon: UIImage(named: "globe")!)
            let weeks = TabBarIconModel(icon: UIImage(named: "calendar icon")!, selectedIcon: UIImage(named: "calendar icon selected")!)
            let weather = TabBarIconModel(icon: UIImage(named: "cloud icon")!, selectedIcon: UIImage(named: "cloud icon selected")!)
            let marker = TabBarIconModel(icon: UIImage(named: "marker")!, selectedIcon: UIImage(named: "marker selected")!)
            return [news, favourites, timetable, maps, settings, sections, weeks, weather, marker]
        case .apple:
            let news = TabBarIconModel(icon: UIImage(systemName: "newspaper")!, selectedIcon: UIImage(systemName: "newspaper.fill")!)
            let favourites = TabBarIconModel(icon: UIImage(systemName: "calendar")!, selectedIcon: UIImage(systemName: "calendar")!)
            let timetable = TabBarIconModel(icon: UIImage(systemName: "clock")!, selectedIcon: UIImage(systemName: "clock.fill")!)
            let maps = TabBarIconModel(icon: UIImage(systemName: "map")!, selectedIcon: UIImage(systemName: "map.fill")!)
            let settings = TabBarIconModel(icon: UIImage(systemName: "gearshape")!, selectedIcon: UIImage(systemName: "gearshape.fill")!)
            let sections = TabBarIconModel(icon: UIImage(systemName: "globe")!, selectedIcon: UIImage(systemName: "globe")!)
            let weeks = TabBarIconModel(icon: UIImage(systemName: "list.bullet")!, selectedIcon: UIImage(systemName: "list.bullet")!)
            let weather = TabBarIconModel(icon: UIImage(systemName: "cloud")!, selectedIcon: UIImage(systemName: "cloud.fill")!)
            let marker = TabBarIconModel(icon: UIImage(systemName: "mappin.circle")!, selectedIcon: UIImage(systemName: "mappin.circle.fill")!)
            return [news, favourites, timetable, maps, settings, sections, weeks, weather, marker]
        }
    }
    
    func checkTabsAnimationOption()-> Bool {
        let option = UserDefaults.standard.object(forKey: "onTabsAnimation") as? Bool ?? true
        return option
    }
    
    func getTabOptions(title: String)-> [TabOptionModel] {
        var data = [TabOptionModel]()
        if let result = UserDefaults.standard.object(forKey: "\(title) options") as? Data {
            do {
                data = try JSONDecoder().decode([TabOptionModel].self, from: result)
            } catch {
                print(error)
            }
        }
        return data
    }
    
    func observeTabsChanged(completion: @escaping()->Void) {
        NotificationCenter.default.addObserver(forName: Notification.Name("tabs changed"), object: nil, queue: .main) { _ in
            completion()
        }
    }
    
    // MARK: - Settable Communication
    func getSavedCommunicationStyle()-> CommunicationStyles {
        let savedStyle = UserDefaults.loadData(type: CommunicationStyles.self, key: "communication style") ?? .formal
        return savedStyle
    }
}
