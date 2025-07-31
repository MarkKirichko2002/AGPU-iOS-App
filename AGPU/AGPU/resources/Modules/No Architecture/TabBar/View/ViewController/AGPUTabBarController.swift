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
        observeDataRefreshed()
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
            handleSounds()
        } else {
            animation.tabBarItemSpringAnimation(item: item)
        }
    }
    
    private func handleSounds() {
        let soundOption = settingsManager.getTabsSoundsOption()
        if soundOption != .none {
            AudioPlayerClass.shared.playSound(sound: soundOption.sound, isPlaying: false)
        }
    }
    
    private func setUpView() {
        view.backgroundColor = .systemBackground
        UITabBar.appearance().backgroundColor = .systemBackground
    }
    
    private func setUpTab() {
        settingsManager.observeOnlyMainChangedOption {
            self.removeViews()
            self.resetSavedTab()
            self.setUpTabs()
        }
        settingsManager.observeTabsChanged {
            self.removeViews()
            self.resetSavedTab()
            self.setUpTabBars()
            self.setUpTabs()
        }
        setUpTabBars()
        setUpTabs()
    }
    
    private func removeViews() {
        for view in tabBar.subviews {
            view.removeFromSuperview()
        }
        viewControllers = nil
    }
    
    private func setUpTabBars() {
        let icons = settingsManager.getTabsIcons()
        // новости
        newsVC.tabBarItem = UITabBarItem(title: "Новости", image: icons[0].icon, selectedImage: icons[0].selectedIcon)
        // избранное
        sectionsListVC.tabBarItem = UITabBarItem(title: "Разделы", image: icons[1].icon, selectedImage: icons[1].selectedIcon)
        // расписание
        self.timetableContainerVC.tabBarItem = UITabBarItem(title: "Расписание", image: icons[2].icon, selectedImage: icons[2].selectedIcon)
        // кнопка
        middleButton.tabBarItem = UITabBarItem(title: "", image: UIImage(named: ""), selectedImage: UIImage(named: ""))
        // карты
        mapsVC.tabBarItem = UITabBarItem(title: "Карты", image: icons[3].icon, selectedImage: icons[3].selectedIcon)
        // настройки
        settingsVC.tabBarItem = UITabBarItem(title: "Настройки", image: icons[4].icon, selectedImage: icons[4].selectedIcon)
        // разделы
        sectionsVC.tabBarItem = UITabBarItem(title: "Разделы", image: icons[5].icon, selectedImage: icons[5].selectedIcon)
        sectionsVC.isMain = true
        viewControllers?.removeAll()
    }
    
    private func setUpTabs() {
        
        let nav1VC = UINavigationController(rootViewController: newsVC)
        let nav2VC = UINavigationController(rootViewController: sectionsListVC)
        let nav3VC = timetableContainerVC
        let nav4VC = UINavigationController(rootViewController: mapsVC)
        let nav5VC = UINavigationController(rootViewController: settingsVC)
        let nav6VC = UINavigationController(rootViewController: sectionsVC)
        
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
            selectedIndex = 0
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
            selectedIndex = 0
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
            selectedIndex = 0
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
            selectedIndex = 0
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
            
            tabs.forEach { customFont(item: $0.tabBarItem)}
            
            setViewControllers(tabs, animated: false)
            
            setUpSavedTab()
            
            if variant == .button {
                ASPUButton.isHidden = false
                disableTab()
            } else {
                ASPUButton.isHidden = true
            }
            
            UITabBar.appearance().tintColor = settingsManager.getTabsColor().color
        }
        setUpTabBarGestures()
        setUpContextMenu()
    }
    
    func resetSavedTab() {
        UserDefaults.standard.set(0, forKey: "index")
    }
    
    func setUpSavedTab() {
        if settingsManager.checkOnlyMainOption() == .custom {
            selectedIndex = UserDefaults.standard.integer(forKey: "index")
        }
    }
    
    func customFont(item: UITabBarItem) {
        let savedFont = settingsManager.getTabsFont()
        let savedColor = settingsManager.getTabsColor()
        if savedFont != .none {
            let font = UIFont(name: savedFont.rawValue, size: 11)
            let attributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: savedColor.color]
            item.setTitleTextAttributes(attributes, for: .normal)
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
        let icons = settingsManager.getTabsIcons()
        let main = settingsManager.checkOnlyMainOption()
        switch main {
        case .schedule:
            makeForTimetable(icons: icons)
        case .news:
            makeForNews(icons: icons)
        case .sections:
            makeForSections(icons: icons)
        case .main:
            makeForMain(icons: icons)
        case .custom:
            makeForCustom(icons: icons)
        }
    }
    
    func makeForTimetable(icons: [TabBarIconModel]) {
        let timetableListInteraction = UIContextMenuInteraction(delegate: self)
        let settingsListInteraction = UIContextMenuInteraction(delegate: self)
        
        if let timetableIndex = viewControllers?.firstIndex(where: { $0.tabBarItem.image == icons[2].icon}) {
            tabBar.subviews[timetableIndex].addInteraction(timetableListInteraction)
            tabBar.subviews[timetableIndex].accessibilityIdentifier = "timetable"
        }
        
        if let settingsIndex = viewControllers?.firstIndex(where: { $0.tabBarItem.image == icons[4].icon}) {
            tabBar.subviews[settingsIndex].addInteraction(settingsListInteraction)
            tabBar.subviews[settingsIndex].accessibilityIdentifier = "settings"
        }
    }
    
    func makeForNews(icons: [TabBarIconModel]) {
        let newsListInteraction = UIContextMenuInteraction(delegate: self)
        let settingsListInteraction = UIContextMenuInteraction(delegate: self)
        if let newsIndex = viewControllers?.firstIndex(where: { $0.tabBarItem.image == icons[0].icon}) {
            tabBar.subviews[newsIndex].addInteraction(newsListInteraction)
            tabBar.subviews[newsIndex].accessibilityIdentifier = "news"
        }
        if let settingsIndex = viewControllers?.firstIndex(where: { $0.tabBarItem.image == icons[4].icon}) {
            tabBar.subviews[settingsIndex].addInteraction(settingsListInteraction)
            tabBar.subviews[settingsIndex].accessibilityIdentifier = "settings"
        }
    }
    
    func makeForSections(icons: [TabBarIconModel]) {
        let sectionsInteraction = UIContextMenuInteraction(delegate: self)
        let settingsListInteraction = UIContextMenuInteraction(delegate: self)
        if let sectionsIndex = viewControllers?.firstIndex(where: { $0.tabBarItem.image == icons[5].icon}) {
            tabBar.subviews[sectionsIndex].addInteraction(sectionsInteraction)
            tabBar.subviews[sectionsIndex].accessibilityIdentifier = "web sections"
        }
        if let settingsIndex = viewControllers?.firstIndex(where: { $0.tabBarItem.image == icons[4].icon}) {
            tabBar.subviews[settingsIndex].addInteraction(settingsListInteraction)
            tabBar.subviews[settingsIndex].accessibilityIdentifier = "settings"
        }
    }
    
    func makeForMain(icons: [TabBarIconModel]) {
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
    
    func makeForCustom(icons: [TabBarIconModel]) {
        let newsListInteraction = UIContextMenuInteraction(delegate: self)
        let favouriteListInteraction = UIContextMenuInteraction(delegate: self)
        let timetableListInteraction = UIContextMenuInteraction(delegate: self)
        let mapsInteraction = UIContextMenuInteraction(delegate: self)
        let settingsListInteraction = UIContextMenuInteraction(delegate: self)
        let sectionsInteraction = UIContextMenuInteraction(delegate: self)
        let weeksInteraction = UIContextMenuInteraction(delegate: self)
        let weatherInteraction = UIContextMenuInteraction(delegate: self)
        let buildingInteraction = UIContextMenuInteraction(delegate: self)
        if let newsIndex = viewControllers?.firstIndex(where: { $0.tabBarItem.image == icons[0].icon}) {
            tabBar.subviews[newsIndex].addInteraction(newsListInteraction)
            tabBar.subviews[newsIndex].accessibilityIdentifier = "news"
        }
        if let favouriteIndex = viewControllers?.firstIndex(where: { $0.tabBarItem.image == icons[1].icon}) {
            tabBar.subviews[favouriteIndex].addInteraction(favouriteListInteraction)
            tabBar.subviews[favouriteIndex].accessibilityIdentifier = "sections"
        }
        if let timetableIndex = viewControllers?.firstIndex(where: { $0.tabBarItem.image == icons[2].icon}) {
            tabBar.subviews[timetableIndex].addInteraction(timetableListInteraction)
            tabBar.subviews[timetableIndex].accessibilityIdentifier = "timetable"
        }
        if let mapsIndex = viewControllers?.firstIndex(where: { $0.tabBarItem.image == icons[3].icon}) {
            tabBar.subviews[mapsIndex].addInteraction(mapsInteraction)
            tabBar.subviews[mapsIndex].accessibilityIdentifier = "maps"
        }
        if let settingsIndex = viewControllers?.firstIndex(where: { $0.tabBarItem.image == icons[4].icon}) {
            tabBar.subviews[settingsIndex].addInteraction(settingsListInteraction)
            tabBar.subviews[settingsIndex].accessibilityIdentifier = "settings"
        }
        if let sectionsIndex = viewControllers?.firstIndex(where: { $0.tabBarItem.image == icons[5].icon}) {
            tabBar.subviews[sectionsIndex].addInteraction(sectionsInteraction)
            tabBar.subviews[sectionsIndex].accessibilityIdentifier = "web sections"
        }
        if let weeksIndex = viewControllers?.firstIndex(where: { $0.tabBarItem.image == icons[6].icon}) {
            tabBar.subviews[weeksIndex].addInteraction(weeksInteraction)
            tabBar.subviews[weeksIndex].accessibilityIdentifier = "weeks"
        }
        if let weatherIndex = viewControllers?.firstIndex(where: { $0.tabBarItem.image == icons[7].icon}) {
            tabBar.subviews[weatherIndex].addInteraction(weatherInteraction)
            tabBar.subviews[weatherIndex].accessibilityIdentifier = "weather"
        }
        
        if let buildingIndex = viewControllers?.firstIndex(where: { $0.tabBarItem.image == icons[8].icon}) {
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
        ASPUButton.setImage(UIImage(named: settingsManager.checkCurrentIcon()), for: .normal)
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
        setUpButtonGestures()
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
        self.updateASPUButton(icon: "button")
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
            updateASPUButton(icon: "left icon")
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                self.updateASPUButton(icon: self.settingsManager.checkCurrentIcon())
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
            updateASPUButton(icon: "left icon")
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                self.updateASPUButton(icon: self.settingsManager.checkCurrentIcon())
            }
        }
        updateASPUButton(icon: "left icon")
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
            updateASPUButton(icon: "right icon")
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                self.updateASPUButton(icon: self.settingsManager.checkCurrentIcon())
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
            updateASPUButton(icon: "right icon")
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                self.updateASPUButton(icon: self.settingsManager.checkCurrentIcon())
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
            case .things:
                openThingsCategoriesList()
            case .whatsNew:
                openWhatsNew()
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
    
    func checkActionToControl() {
        if settingsManager.checkActionToControlOption() {
            if !self.hidesBottomBarWhenPushed && (self.presentedViewController == nil) {
                openRecentMoments()
            }
        } else {
            if !ASPUButton.isHidden {
                self.updateASPUButton(icon: "info icon")
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                    let vc = HintViewController(info: "Отключена фишка Action To Control! Чтобы дальше пользоваться данной фишкой нужно включить ее в настройках.")
                    vc.isNotify = true
                    vc.delegate = self
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                }
            } else {
                let vc = HintViewController(info: "Отключена фишка Action To Control! Чтобы дальше пользоваться данной фишкой нужно включить ее в настройках.")
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }
        }
    }
    
    // MARK: - Selected Faculty
    private func observeFaculty() {
        NotificationCenter.default.addObserver(forName: Notification.Name("icon"), object: nil, queue: .main) { notification in
            if let icon = notification.object as? String {
                self.updateASPUButton(icon: icon)
            } else {
                self.updateASPUButton(icon: "АГПУ")
            }
        }
    }
    
    // MARK: - Adaptive News
    private func observeArticleSelected() {
        NotificationCenter.default.addObserver(forName: Notification.Name("article selected"), object: nil, queue: .main) { _ in
            self.updateASPUButton(icon: "info icon")
        }
    }
    
    private func observeDataRefreshed() {
        NotificationCenter.default.addObserver(forName: Notification.Name("refreshed"), object: nil, queue: .main) { _ in
            self.updateASPUButton(icon: "refresh icon")
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                self.updateASPUButton(icon: self.settingsManager.checkCurrentIcon())
            }
        }
    }
}
