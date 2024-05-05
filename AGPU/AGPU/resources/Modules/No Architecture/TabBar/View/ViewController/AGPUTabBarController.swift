//
//  AGPUTabBarController.swift
//  AGPU
//
//  Created by Марк Киричко on 09.06.2023.
//

import UIKit

final class AGPUTabBarController: UITabBarController {
    
    // MARK: - сервисы
    let speechRecognitionManager = SpeechRecognitionManager()
    let animation = AnimationClass()
    let settingsManager = SettingsManager()
    
    // MARK: - вкладки
    // новости
    let newsVC = NewsListViewController()
    // для каждого статуса
    var forEveryStatusVC = UIViewController()
    // кнопка
    let middleButton = UIViewController()
    // расписание
    let timetableVC = TimeTableDayListTableViewController()
    // настройки
    let settingsVC = SettingsListViewController()
    
    var isRecording = false
    
    var isOpened = false
    
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
        setUpTabs()
        createMiddleButton()
        observeForEveryStatus()
        observeScreen()
        observeFaculty()
        observeArticleSelected()
        observeDataRefreshed()
        becomeFirstResponder()
        checkForUpdates()
    }
    
    override var selectedViewController: UIViewController? {
        didSet {
            handleTab(index: selectedIndex)
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let isOnAnimation = settingsManager.checkTabsAnimationOption()
        if isOnAnimation {
            animation.tabBarItemSpringAnimation(item: item)
        }
    }
    
    private func handleTab(index: Int) {
        let isRecentTab = UserDefaults.standard.object(forKey: "onRecentTab") as? Bool ?? true
        if isRecentTab {
            UserDefaults.standard.setValue(selectedIndex, forKey: "index")
        } else {
            print("выключено")
        }
    }
    
    private func setUpView() {
        view.backgroundColor = .systemBackground
        UITabBar.appearance().backgroundColor = .systemBackground
    }
    
    private func setUpTab() {
        settingsManager.observeStatusChanged {
            DispatchQueue.main.async {
                self.setUpTabs()
                self.selectedIndex = 4
            }
        }
        settingsManager.observeOnlyTimetableChanged {
            DispatchQueue.main.async {
                self.setUpTabs()
            }
        }
        settingsManager.observeTabsChanged {
            DispatchQueue.main.async {
                self.setUpTabs()
            }
        }
    }
    
    private func setUpTabs() {
        // новости
        newsVC.tabBarItem = UITabBarItem(title: "Новости", image: UIImage(named: "mail"), selectedImage: UIImage(named: "mail selected"))
        // расписание
        timetableVC.tabBarItem = UITabBarItem(title: "Расписание", image: UIImage(named: "time icon"), selectedImage: UIImage(named: "time icon selected"))
        // настройки
        settingsVC.tabBarItem = UITabBarItem(title: "Настройки", image: UIImage(named: "settings"), selectedImage: UIImage(named: "settings selected"))
        let nav1VC = UINavigationController(rootViewController: newsVC)
        let nav3VC = UINavigationController(rootViewController: timetableVC)
        let nav4VC = UINavigationController(rootViewController: settingsVC)
        
        let onlyTimetable = UserDefaults.standard.object(forKey: "onOnlyTimetable") as? Bool ?? false
                
        if onlyTimetable {
            setViewControllers([nav3VC, middleButton, nav4VC], animated: false)
        } else {
            let position = settingsManager.getTabsPosition()
            forEveryStatusVC = settingsManager.checkCurrentStatus()
            var tabs = [nav1VC, forEveryStatusVC, nav3VC, nav4VC]
           
            for tab in tabs {
                
                for number in position {
                    let index = tabs.firstIndex(of: tab)!
                    tabs.swapAt(index, number)
                }
            }
            
            tabs.insert(middleButton, at: 2)
            setViewControllers(tabs, animated: false)
            selectedIndex = UserDefaults.standard.integer(forKey: "index")
        }
        UITabBar.appearance().tintColor = self.settingsManager.getTabsColor().color
    }
    
    // MARK: - ASPU Button
    private func createMiddleButton() {
        ASPUButton.setImage(UIImage(named: settingsManager.checkCurrentIcon()), for: .normal)
        ASPUButton.frame = CGRect(x: 0, y: 0, width: 64, height: 64)
        // Устанавливаем положение кнопки по середине TabBar
        ASPUButton.center = CGPoint(x: tabBar.frame.width / 2, y: tabBar.frame.height / 2 - 5)
        settingsManager.observeASPUButtonActionChanged {
            self.currentAction()
        }
        // Назначаем действие для кнопки
        currentAction()
        // Добавляем кнопку на TabBar
        tabBar.addSubview(ASPUButton)
    }
     
    private func currentAction() {
        let action = settingsManager.checkASPUButtonOption()
        ASPUButton.removeTarget(nil, action: nil, for: .allEvents)
        switch action {
        case .speechRecognition:
            ASPUButton.addTarget(self, action: #selector(VoiceCommands), for: .touchUpInside)
        case .timetableWeeks:
            ASPUButton.addTarget(self, action: #selector(openWeeksTimetable), for: .touchUpInside)
        case .campusMap:
            ASPUButton.addTarget(self, action: #selector(openCampusMap), for: .touchUpInside)
        case .studyPlan:
            ASPUButton.addTarget(self, action: #selector(openStudyPlan), for: .touchUpInside)
        case .profile:
            ASPUButton.addTarget(self, action: #selector(openProfile), for: .touchUpInside)
        case .manual:
            ASPUButton.addTarget(self, action: #selector(openManual), for: .touchUpInside)
        case .recent:
            ASPUButton.addTarget(self, action: #selector(openRecentMoments), for: .touchUpInside)
        case .favourite:
            ASPUButton.addTarget(self, action: #selector(openFavouritesList), for: .touchUpInside)
        }
    }
    
    // MARK: - Action To Recall
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        checkActionToRecall()
    }
    
    func checkActionToRecall() {
        if settingsManager.checkShakeToRecallOption() {
            openRecentMoments()
        } else {
            self.updateASPUButton(icon: "info icon")
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
                let ok = UIAlertAction(title: "ОК", style: .default)
                self.showAlert(title: "Вы отключили фишку Action To Recall!", message: "чтобы дальше пользоваться данной фишкой включите ее в настройках.", actions: [ok])
                self.updateASPUButton(icon: self.settingsManager.checkCurrentIcon())
            }
        }
    }
    
     @objc func openRecentMoments() {
        let vc = RecentMomentsListTableViewController()
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        self.updateASPUButton(icon: "time.past")
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            self.present(navVC, animated: true)
        }
    }
    
    @objc func VoiceCommands() {
        isRecording = !isRecording
        if isRecording {
            self.updateASPUButton(icon: "mic")
            speechRecognitionManager.requestSpeechAndMicrophonePermission()
            speechRecognitionManager.registerSpeechAuthorizationHandler { auth in
                switch auth {
                case .notDetermined:
                    print("Разрешение на распознавание речи еще не было получено.")
                case .denied:
                    let settingsAction = UIAlertAction(title: "Перейти в настройки", style: .default) { _ in
                        self.openSettings()
                    }
                    let cancel = UIAlertAction(title: "Отмена", style: .destructive) { _ in
                        self.ASPUButton.sendActions(for: .touchUpInside)
                    }
                    self.showAlert(title: "Микрофон выключен", message: "Хотите включить в настройках?", actions: [settingsAction, cancel])
                    print("Доступ к распознаванию речи был отклонен.")
                case .restricted:
                    print("Функциональность распознавания речи ограничена.")
                case .authorized:
                    print("Разрешение на распознавание речи получено.")
                    self.speechRecognitionManager.startRecognize()
                @unknown default:
                    print("неизвестно")
                }
            }
            speechRecognitionManager.registerSpeechRecognitionHandler { text in
                self.checkVoiceCommands(text: text)
            }
        } else {
            self.updateASPUButton(icon: self.settingsManager.checkCurrentIcon())
            speechRecognitionManager.cancelSpeechRecognition()
        }
    }
    
    // MARK: - Voice Control
    private func checkVoiceCommands(text: String) {
        if isOpened {
            changeSection(text: text.lowercased())
            randomSectionOnScreen(text: text.lowercased())
            changeSubSection(text: text.lowercased())
            changeBuilding(text: text.lowercased())
            scrollWebScreen(text: text.lastWord())
            webActions(text: text.lowercased())
        } else {
            searchSection(text: text.lowercased())
            generateRandomSection(text: text.lowercased())
            searchSubSection(text: text.lowercased())
            findBuilding(text: text.lowercased())
        }
        turnOfMicrophone(text: text.lowercased())
    }
    
    @objc func openWeeksTimetable() {
        let id = UserDefaults.standard.string(forKey: "group") ?? "ВМ-ИВТ-2-1"
        let subgroup = UserDefaults.standard.integer(forKey: "subgroup")
        let owner = UserDefaults.standard.string(forKey: "recentOwner") ?? "GROUP"
        let vc = AllWeeksListTableViewController(id: id, subgroup: subgroup, owner: owner)
        vc.isNotify = true
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        self.updateASPUButton(icon: "clock")
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            self.present(navVC, animated: true)
        }
    }
    
    @objc func openCampusMap() {
        let vc = AGPUBuildingsMapViewController()
        vc.isAction = true
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        self.updateASPUButton(icon: "map icon")
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            self.present(navVC, animated: true)
        }
    }
    
    @objc func openStudyPlan() {
        self.updateASPUButton(icon: "student")
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            self.goToWeb(url: "http://plany.agpu.net/Plans/", image: "student", title: "Учебный план", isSheet: false, isNotify: true)
        }
    }
    
    
    @objc func openProfile() {
        self.updateASPUButton(icon: "profile icon")
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            self.goToWeb(url: "http://plany.agpu.net/WebApp/#/", image: "profile icon", title: "ЭИОС", isSheet: false, isNotify: true)
        }
    }
    
    @objc func openManual() {
        if let cathedra = UserDefaults.loadData(type: FacultyCathedraModel.self, key: "cathedra") {
            self.updateASPUButton(icon: "book")
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                self.goToWeb(url: cathedra.manualUrl, image: "book", title: "Метод. материалы", isSheet: false, isNotify: true)
            }
        } else {
            self.showHintAlert(type: .manuals)
            HapticsManager.shared.hapticFeedback()
        }
    }
    
    @objc func openFavouritesList() {
        let vc = ASPUButtonFavouriteActionsListTableViewController()
        vc.delegate = self
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        self.updateASPUButton(icon: "star")
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            self.present(navVC, animated: true)
        }
    }
    
    private func observeForEveryStatus() {
        NotificationCenter.default.addObserver(forName: Notification.Name("for every status selected"), object: nil, queue: .main) { notification in
            if let icon = notification.object as? String {
                self.updateASPUButton(icon: icon)
            }
        }
    }
    
    private func observeScreen() {
        NotificationCenter.default.addObserver(forName: Notification.Name("screen was closed"), object: nil, queue: .main) { _ in
            if self.isRecording {
                if !self.tabBar.isHidden {
                    self.updateASPUButton(icon: "mic")
                }
            } else {
                if !self.tabBar.isHidden {
                    self.updateASPUButton(icon: self.settingsManager.checkCurrentIcon())
                }
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
