//
//  AGPUTabBarController.swift
//  AGPU
//
//  Created by Марк Киричко on 09.06.2023.
//

import UIKit

final class AGPUTabBarController: UITabBarController {
    
    // MARK: - сервисы
    let animation = AnimationClass()
    let settingsManager = SettingsManager()
    
    // MARK: - вкладки
    // новости
    let newsVC = NewsListViewController()
    // разделы
    var sectionsListVC = FavouriteSectionsListViewController()
    // кнопка
    let middleButton = UIViewController()
    // расписание
    let timetableContainerVC = TimeTableContainerViewController()
    // карты
    let mapsVC = SimpleMapViewController()
    // настройки
    let settingsVC = SettingsListViewController()
    // разделы
    let sectionsVC = ASPUWebsiteSectionsListViewController()
    
    private lazy var nav1VC: UINavigationController = {
        UINavigationController(rootViewController: newsVC)
    }()
    
    private lazy var nav2VC: UINavigationController = {
        UINavigationController(rootViewController: sectionsListVC)
    }()
    
    private lazy var nav3VC: UIViewController = {
        timetableContainerVC
    }()
    
    private lazy var nav4VC: UINavigationController = {
        UINavigationController(rootViewController: mapsVC)
    }()
    
    private lazy var nav5VC: UINavigationController = {
        UINavigationController(rootViewController: settingsVC)
    }()
    
    private lazy var nav6VC: UINavigationController = {
        UINavigationController(rootViewController: sectionsVC)
    }()
    
    var buttonPosition: CGFloat = 0
    
    // MARK: - ASPU Button
    let ASPUButton: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpTab()
        calculateButtonPosition()
        createMiddleButton()
        observeFaculty()
        observeArticleSelected()
        checkForUpdates()
        becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        createMiddleButton()
    }
    
    override var selectedViewController: UIViewController? {
        didSet {
            handleTab(item: tabBar.selectedItem!)
        }
    }
    
    private func handleTab(item: UITabBarItem) {
        let isRecentTab = UserDefaults.standard.object(forKey: "onRecentTab") as? Bool ?? true
        let isOnAnimation = settingsManager.checkTabsAnimationOption()
        let main = settingsManager.checkOnlyMainOption()
        if main == .custom {
            if isRecentTab {
                UserDefaults.standard.setValue(selectedIndex, forKey: "index")
            }
            if isOnAnimation {
                animation.tabBarItemSpringAnimation(item: item)
            }
        } else {
            animation.tabBarItemSpringAnimation(item: item)
        }
    }
    
    private func setUpView() {
        view.backgroundColor = .systemBackground
        UITabBar.appearance().backgroundColor = .systemBackground
    }
    
    private func setUpTab() {
        setUpTabBars()
        setUpTabs()
    }
    
    func removeViews() {
        for view in tabBar.subviews {
            view.removeFromSuperview()
        }
        viewControllers = nil
    }
    
    func setUpTabBars() {
        // новости
        newsVC.tabBarItem = UITabBarItem(title: "Новости", image: UIImage(named: "mail")!, selectedImage: UIImage(named: "mail selected")!)
        // избранное
        sectionsListVC.tabBarItem = UITabBarItem(title: "Разделы", image: UIImage(named: "sections")!, selectedImage: UIImage(named: "sections")!)
        // расписание
        self.timetableContainerVC.tabBarItem = UITabBarItem(title: "Расписание", image: UIImage(named: "time icon")!, selectedImage: UIImage(named: "time icon selected")!)
        // кнопка
        middleButton.tabBarItem = UITabBarItem(title: "", image: UIImage(named: ""), selectedImage: UIImage(named: ""))
        // карты
        mapsVC.tabBarItem = UITabBarItem(title: "Карты", image: UIImage(named: "map")!, selectedImage: UIImage(named: "map selected")!)
        // настройки
        settingsVC.tabBarItem = UITabBarItem(title: "Настройки", image: UIImage(named: "settings")!, selectedImage: UIImage(named: "settings selected")!)
        // разделы
        sectionsVC.tabBarItem = UITabBarItem(title: "Разделы", image: UIImage(named: "globe")!, selectedImage: UIImage(named: "globe")!)
        sectionsVC.isMain = true
        viewControllers?.removeAll()
    }
    
    func setUpTabs() {
        
        var tabs = [UIViewController]()
        let onlyMain = settingsManager.checkOnlyMainOption()
        
        switch onlyMain {
        case .schedule:
            tabs = [nav3VC, nav5VC]
            tabs[0].tabBarItem.title = "Расписание"
            tabs[1].tabBarItem.title = "Настройки"
            tabs.forEach { makeStandardFont(item: $0.tabBarItem)}
            tabs.insert(middleButton, at: 1)
            setViewControllers(tabs, animated: false)
            UITabBar.appearance().tintColor = .label
            ASPUButton.isHidden = false
            disableTab()
        case .news:
            tabs = [nav1VC, nav5VC]
            tabs[0].tabBarItem.title = "Новости"
            tabs[1].tabBarItem.title = "Настройки"
            tabs.forEach { makeStandardFont(item: $0.tabBarItem)}
            tabs.insert(middleButton, at: 1)
            setViewControllers(tabs, animated: false)
            UITabBar.appearance().tintColor = .label
            ASPUButton.isHidden = false
            disableTab()
        case .sections:
            tabs = [nav6VC, nav5VC]
            tabs[0].tabBarItem.title = "Разделы"
            tabs[1].tabBarItem.title = "Настройки"
            tabs.forEach { makeStandardFont(item: $0.tabBarItem)}
            tabs.insert(middleButton, at: 1)
            setViewControllers(tabs, animated: false)
            UITabBar.appearance().tintColor = .label
            ASPUButton.isHidden = false
            disableTab()
        case .main:
            tabs = [nav1VC, nav3VC, nav4VC, nav5VC]
            tabs[0].tabBarItem.title = "Новости"
            tabs[1].tabBarItem.title = "Расписание"
            tabs[2].tabBarItem.title = "Карты"
            tabs[3].tabBarItem.title = "Настройки"
            tabs.forEach { makeStandardFont(item: $0.tabBarItem)}
            tabs.insert(middleButton, at: 2)
            setViewControllers(tabs, animated: false)
            UITabBar.appearance().tintColor = .label
            ASPUButton.isHidden = false
            disableTab()
        case .custom:
            let savedTabs = settingsManager.getTabs()
            let variant = settingsManager.getAdditionalTabVariant()
            let additionalTab = settingsManager.getAdditionalTab()
            tabs = [nav1VC, nav2VC, nav3VC, nav5VC]
            
            for tab in tabs {
                for savedTab in savedTabs {
                    let index = tabs.firstIndex(of: tab)!
                    tabs.swapAt(index, savedTab.position)
                }
            }
            
            for i in 0...savedTabs.count - 1 {
                tabs[i].tabBarItem.title = savedTabs[i].name
            }
            
            if variant != .none {
                tabs.insert(additionalTab, at: 2)
            }
            
            setUpFontForTabs(tabs: tabs)
            
            setViewControllers(tabs, animated: false)
            
            if variant == .button {
                ASPUButton.isHidden = false
                disableTab()
            } else {
                ASPUButton.isHidden = true
            }
            
            setUpSavedTab()
            UITabBar.appearance().tintColor = settingsManager.getTabsColor().color
        }
        setUpTabBarGestures()
        setUpContextMenu()
    }
    
    func resetTabIndex() {
        selectedIndex = 1
        selectedIndex = 0
        UserDefaults.standard.set(0, forKey: "index")
    }
    
    func setUpSavedTab() {
        if settingsManager.checkOnlyMainOption() == .custom {
            selectedIndex = UserDefaults.standard.integer(forKey: "index")
        }
    }
    
    func setUpFontForTabs(tabs: [UIViewController]) {
        let savedTabs = settingsManager.getTabs()
        if settingsManager.getAdditionalTabVariant() == .none {
            for i in 0...3 {
                let title = savedTabs[i].tabName
                setUpFontForTab(tab: tabs[i].tabBarItem, title: title)
            }
        } else {
            // первые две вкладки
            for i in 0...1 {
                let title = savedTabs[i].tabName
                setUpFontForTab(tab: tabs[i].tabBarItem, title: title)
            }
            // дополнительная вкладка
            let title = settingsManager.getAdditionalTabVariant().rawValue
            setUpFontForTab(tab: tabs[2].tabBarItem, title: title)
            // другие две вкладки
            for i in 3...4 {
                let title = savedTabs[i - 1].tabName
                setUpFontForTab(tab: tabs[i].tabBarItem, title: title)
            }
        }
    }
    
    func setUpFontForTab(tab: UITabBarItem, title: String) {
        let savedColor = settingsManager.getTabsColor()
        let savedFont = settingsManager.getTabFont(title: title)
        if savedFont != .none {
            let font = UIFont(name: savedFont.rawValue, size: 11)
            let attributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: savedColor.color]
            tab.setTitleTextAttributes(attributes, for: .normal)
        }
    }
    
    func makeStandardFont(item: UITabBarItem) {
        let font = UIFont.systemFont(ofSize: 11)
        let attributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.label]
        item.setTitleTextAttributes(attributes, for: .normal)
    }
    
    private func disableTab() {
        if tabBar.items?.count == 5 {
            tabBar.items?[2].isEnabled = false
        } else {
            tabBar.items?[1].isEnabled = false
        }
    }
    
    private func setUpContextMenu() {
        let main = settingsManager.checkOnlyMainOption()
        switch main {
        case .schedule:
            makeForTimetable()
        case .news:
            makeForNews()
        case .sections:
            makeForSections()
        case .main:
            makeForMain()
        case .custom:
            makeForCustom()
        }
    }
    
    func makeForTimetable() {
        let timetableListInteraction = UIContextMenuInteraction(delegate: self)
        let settingsListInteraction = UIContextMenuInteraction(delegate: self)
        
        if let timetableIndex = viewControllers?.firstIndex(where: { $0.tabBarItem.image == UIImage(named: "time icon")}) {
            tabBar.subviews[timetableIndex].addInteraction(timetableListInteraction)
            tabBar.subviews[timetableIndex].accessibilityIdentifier = "timetable"
        }
        
        if let settingsIndex = viewControllers?.firstIndex(where: { $0.tabBarItem.image == UIImage(named: "settings")!}) {
            tabBar.subviews[settingsIndex].addInteraction(settingsListInteraction)
            tabBar.subviews[settingsIndex].accessibilityIdentifier = "settings"
        }
    }
    
    func makeForNews() {
        let newsListInteraction = UIContextMenuInteraction(delegate: self)
        let settingsListInteraction = UIContextMenuInteraction(delegate: self)
        if let newsIndex = viewControllers?.firstIndex(where: { $0.tabBarItem.image == UIImage(named: "mail")!}) {
            tabBar.subviews[newsIndex].addInteraction(newsListInteraction)
            tabBar.subviews[newsIndex].accessibilityIdentifier = "news"
        }
        if let settingsIndex = viewControllers?.firstIndex(where: { $0.tabBarItem.image == UIImage(named: "settings")!}) {
            tabBar.subviews[settingsIndex].addInteraction(settingsListInteraction)
            tabBar.subviews[settingsIndex].accessibilityIdentifier = "settings"
        }
    }
    
    func makeForSections() {
        let sectionsInteraction = UIContextMenuInteraction(delegate: self)
        let settingsListInteraction = UIContextMenuInteraction(delegate: self)
        if let sectionsIndex = viewControllers?.firstIndex(where: { $0.tabBarItem.image == UIImage(named: "globe")!}) {
            tabBar.subviews[sectionsIndex].addInteraction(sectionsInteraction)
            tabBar.subviews[sectionsIndex].accessibilityIdentifier = "web sections"
        }
        if let settingsIndex = viewControllers?.firstIndex(where: { $0.tabBarItem.image == UIImage(named: "settings")!}) {
            tabBar.subviews[settingsIndex].addInteraction(settingsListInteraction)
            tabBar.subviews[settingsIndex].accessibilityIdentifier = "settings"
        }
    }
    
    func makeForMain() {
        let newsListInteraction = UIContextMenuInteraction(delegate: self)
        let timetableListInteraction = UIContextMenuInteraction(delegate: self)
        let mapsInteraction = UIContextMenuInteraction(delegate: self)
        let settingsListInteraction = UIContextMenuInteraction(delegate: self)
        tabBar.subviews[0].addInteraction(newsListInteraction)
        tabBar.subviews[0].accessibilityIdentifier = "news"
        tabBar.subviews[1].addInteraction(timetableListInteraction)
        tabBar.subviews[1].accessibilityIdentifier = "timetable"
        tabBar.subviews[3].addInteraction(mapsInteraction)
        tabBar.subviews[3].accessibilityIdentifier = "maps"
        tabBar.subviews[4].addInteraction(settingsListInteraction)
        tabBar.subviews[4].accessibilityIdentifier = "settings"
    }
    
    func makeForCustom() {
        let newsListInteraction = UIContextMenuInteraction(delegate: self)
        let favouriteListInteraction = UIContextMenuInteraction(delegate: self)
        let timetableListInteraction = UIContextMenuInteraction(delegate: self)
        let mapsInteraction = UIContextMenuInteraction(delegate: self)
        let settingsListInteraction = UIContextMenuInteraction(delegate: self)
        let sectionsInteraction = UIContextMenuInteraction(delegate: self)
        let weeksInteraction = UIContextMenuInteraction(delegate: self)
        let weatherInteraction = UIContextMenuInteraction(delegate: self)
        let buildingInteraction = UIContextMenuInteraction(delegate: self)
        if let newsIndex = viewControllers?.firstIndex(where: { $0.tabBarItem.image == UIImage(named: "mail")!}) {
            tabBar.subviews[newsIndex].addInteraction(newsListInteraction)
            tabBar.subviews[newsIndex].accessibilityIdentifier = "news"
        }
        if let favouriteIndex = viewControllers?.firstIndex(where: { $0.tabBarItem.image == UIImage(named: "sections")!}) {
            tabBar.subviews[favouriteIndex].addInteraction(favouriteListInteraction)
            tabBar.subviews[favouriteIndex].accessibilityIdentifier = "sections"
        }
        if let timetableIndex = viewControllers?.firstIndex(where: { $0.tabBarItem.image == UIImage(named: "time icon")!}) {
            tabBar.subviews[timetableIndex].addInteraction(timetableListInteraction)
            tabBar.subviews[timetableIndex].accessibilityIdentifier = "timetable"
        }
        if let mapsIndex = viewControllers?.firstIndex(where: { $0.tabBarItem.image == UIImage(named: "map")!}) {
            tabBar.subviews[mapsIndex].addInteraction(mapsInteraction)
            tabBar.subviews[mapsIndex].accessibilityIdentifier = "maps"
        }
        if let settingsIndex = viewControllers?.firstIndex(where: { $0.tabBarItem.image == UIImage(named: "settings")!}) {
            tabBar.subviews[settingsIndex].addInteraction(settingsListInteraction)
            tabBar.subviews[settingsIndex].accessibilityIdentifier = "settings"
        }
        if let sectionsIndex = viewControllers?.firstIndex(where: { $0.tabBarItem.image == UIImage(named: "globe")!}) {
            tabBar.subviews[sectionsIndex].addInteraction(sectionsInteraction)
            tabBar.subviews[sectionsIndex].accessibilityIdentifier = "web sections"
        }
        if let weeksIndex = viewControllers?.firstIndex(where: { $0.tabBarItem.image == UIImage(named: "calendar icon")!}) {
            tabBar.subviews[weeksIndex].addInteraction(weeksInteraction)
            tabBar.subviews[weeksIndex].accessibilityIdentifier = "weeks"
        }
        if let weatherIndex = viewControllers?.firstIndex(where: { $0.tabBarItem.image == UIImage(named: "cloud icon")!}) {
            tabBar.subviews[weatherIndex].addInteraction(weatherInteraction)
            tabBar.subviews[weatherIndex].accessibilityIdentifier = "weather"
        }
        
        if let buildingIndex = viewControllers?.firstIndex(where: { $0.tabBarItem.image ==  UIImage(named: "marker")!}) {
            tabBar.subviews[buildingIndex].addInteraction(buildingInteraction)
            tabBar.subviews[buildingIndex].accessibilityIdentifier = "building"
        }
    }
    
    private func calculateButtonPosition() {
        if UIDevice.isiPhone {
            buttonPosition = tabBar.frame.height / 2 - 5
        } else {
            buttonPosition = tabBar.frame.height / 2 - 10
        }
    }
    
    // MARK: - ASPU Button
    private func createMiddleButton() {
        ASPUButton.setImage(UIImage(data: settingsManager.checkCurrentIcon().icon), for: .normal)
        ASPUButton.frame = CGRect(x: 0, y: 0, width: 64, height: 64)
        if UIDevice.isiPhone {
            ASPUButton.center = CGPoint(x: tabBar.frame.width / 2, y: buttonPosition)
        } else {
            ASPUButton.center = CGPoint(x: tabBar.frame.width / 2, y: buttonPosition)
        }
        setUpButton()
        tabBar.addSubview(ASPUButton)
    }
    
    private func setUpButton() {
        settingsManager.observeASPUButtonActionChanged {
            self.refreshGestures()
        }
        setUpButtonShape()
        setUpButtonGestures()
    }
    
    func setUpButtonShape() {
        if settingsManager.checkCurrentIcon().id == 6 {
            ASPUButton.imageView?.layer.cornerRadius = ASPUButton.frame.width / 2
            ASPUButton.imageView?.clipsToBounds = true
            ASPUButton.imageView?.layer.borderWidth = 2
            ASPUButton.imageView?.layer.borderColor = UIColor(named: "aspu")?.cgColor
        } else {
            ASPUButton.imageView?.layer.cornerRadius = 0
            ASPUButton.imageView?.clipsToBounds = false
            ASPUButton.imageView?.layer.borderWidth = 0
            ASPUButton.imageView?.layer.borderColor = nil
        }
    }
    
    private func setUpButtonGestures() {
        let gesture = settingsManager.checkASPUButtonGestureOption().gesture
        gesture.addTarget(self, action: #selector(handleGestures))
        ASPUButton.addTarget(self, action: #selector(makeSmth), for: .touchUpInside)
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(openASPUButtonSettings))
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
        swipeUp.direction = .up
        swipeLeft.direction = .left
        swipeRight.direction = .right
        ASPUButton.addGestureRecognizer(swipeUp)
        ASPUButton.addGestureRecognizer(swipeLeft)
        ASPUButton.addGestureRecognizer(swipeRight)
        ASPUButton.addGestureRecognizer(gesture)
    }
    
    private func setUpTabBarGestures() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(showTabBarSettings))
        swipeRight.direction = .right
        tabBar.addGestureRecognizer(swipeRight)
        setUpGestureForTabs()
    }
    
    private func setUpGestureForTabs() {
        if settingsManager.checkOnlyMainOption() == .custom {
            for view in tabBar.subviews {
                let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
                swipeUp.direction = .up
                let index = tabBar.subviews.firstIndex(of: view) ?? 0
                if settingsManager.getAdditionalTabVariant() == .none {
                    tabBar.subviews[index].addGestureRecognizer(swipeUp)
                } else {
                    if index != 2 {
                        tabBar.subviews[index].addGestureRecognizer(swipeUp)
                    }
                }
            }
        }
    }
    
    @objc private func handleSwipe(_ gesture: UITapGestureRecognizer) {
        if let view = gesture.view {
            let vc = CurrentTabFavouriteOptionsListViewController(title: view.accessibilityIdentifier ?? "")
            vc.isSettings = true
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
            HapticsManager.shared.hapticFeedback()
        } else {
            print("хз братан")
        }
    }
    
    @objc private func showTabBarSettings() {
        let vc = OnlyMainVariantsListTableViewController()
        vc.delegate = self
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true)
        HapticsManager.shared.hapticFeedback()
    }
    
    @objc private func makeSmth(sender: UIButton) {
        handleGestures(gesture: sender.gestureRecognizers!.last!)
    }
    
    private func refreshGestures() {
        ASPUButton.gestureRecognizers?.removeAll()
        setUpButtonGestures()
    }
    
    @objc func openASPUButtonSettings() {
        let vc = ASPUButtonOptionsListTableViewController()
        vc.isNotify = true
        vc.delegate = self
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        self.updateASPUButton(icon: UIImage(named: "button")!.pngData()!)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            self.present(navVC, animated: true)
        }
    }
    
    @objc private func swipeLeft() {
        if viewControllers?.count == 5 {
            handleLeftSideForFourTabs()
        } else {
            handleLeftSideForTwoTabs()
        }
    }
    
    func handleLeftSideForFourTabs() {
        if selectedIndex > 0 {
            if selectedIndex == 3 {
                selectedIndex = 1
            } else {
                selectedIndex -= 1
            }
            handleTab(item: tabBar.selectedItem!)
            updateASPUButton(icon: UIImage(named: "left icon")!.pngData()!)
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                self.updateButtonWithCustomImage(icon: self.settingsManager.checkCurrentIcon().icon)
            }
        }
    }
    
    func handleLeftSideForTwoTabs() {
        if selectedIndex > 0 {
            if selectedIndex == 2 {
                selectedIndex = 0
            } else {
                selectedIndex -= 1
            }
            handleTab(item: tabBar.selectedItem!)
            updateASPUButton(icon: UIImage(named: "left icon")!.pngData()!)
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                self.updateButtonWithCustomImage(icon: self.settingsManager.checkCurrentIcon().icon)
            }
        }
        updateASPUButton(icon: UIImage(named: "left icon")!.pngData()!)
    }
    
    @objc private func swipeRight() {
        if viewControllers?.count == 5 {
            handleRightSideForFourTabs()
        } else {
            handleRightSideForTwoTabs()
        }
    }
    
    func handleRightSideForFourTabs() {
        if selectedIndex < 4 {
            if selectedIndex == 1 {
                selectedIndex = 3
            } else {
                selectedIndex += 1
            }
            handleTab(item: tabBar.selectedItem!)
            updateASPUButton(icon: UIImage(named: "right icon")!.pngData()!)
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                self.updateButtonWithCustomImage(icon: self.settingsManager.checkCurrentIcon().icon)
            }
        }
    }
    
    func handleRightSideForTwoTabs() {
        if selectedIndex < 2 {
            if selectedIndex == 0 {
                selectedIndex = 2
            } else {
                selectedIndex += 1
            }
            handleTab(item: tabBar.selectedItem!)
            updateASPUButton(icon: UIImage(named: "right icon")!.pngData()!)
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                self.updateButtonWithCustomImage(icon: self.settingsManager.checkCurrentIcon().icon)
            }
        }
    }
    
    @objc private func handleGestures(gesture: UIGestureRecognizer) {
        let action = settingsManager.checkASPUButtonOption()
        let savedGesture = settingsManager.checkASPUButtonGestureOption()
        if gesture.state == .possible {
            let hintVC = HintViewController(info: "Для активации ASPU Button нужен жест: \(savedGesture.rawValue)")
            hintVC.isNotify = true
            hintVC.delegate = self
            hintVC.modalPresentationStyle = .fullScreen
            present(hintVC, animated: true)
            HapticsManager.shared.hapticFeedback()
        } else if gesture.state == .ended {
            switch action {
            case .speechRecognition:
                openVoiceCommands(isAction: false)
            case .timetableWeeks:
                openWeeksTimetable()
            case .campusMap:
                openCampusMap()
            case .studyPlan:
                openStudyPlan()
            case .profile:
                openProfile()
            case .manual:
                openManual()
            case .sections:
                openSectionsList()
            case .recent:
                openRecentMoments()
            case .weather:
                openWeatherVC()
            case .nearestBuilding:
                showNearestBuilding(isAction: false)
            case .appThemes:
                openAppThemes()
            case .appShortcuts:
                openAppShortcuts()
            case .favourite:
                openFavouritesList()
            }
        }
    }
    
    // MARK: - Selected Faculty
    private func observeFaculty() {
        NotificationCenter.default.addObserver(forName: Notification.Name("icon"), object: nil, queue: .main) { notification in
            if let icon = notification.object as? String {
                self.updateASPUButton(icon: UIImage(named: icon)!.pngData()!)
            } else {
                self.updateASPUButton(icon: UIImage(named: "АГПУ")!.pngData()!)
            }
        }
    }
    
    // MARK: - University News
    private func observeArticleSelected() {
        NotificationCenter.default.addObserver(forName: Notification.Name("article selected"), object: nil, queue: .main) { _ in
            self.updateASPUButton(icon: UIImage(named: "info icon")!.pngData()!)
        }
    }
}
