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
    
    // MARK: - Dynamic Button
    let DynamicButton: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpTabs()
        setUpTab()
        createMiddleButton()
        observeForEveryStatus()
        observeWebScreen()
        observeFaculty()
        observeArticleSelected()
        observeDataRefreshed()
        becomeFirstResponder()
        checkForUpdates()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        animation.tabBarItemAnimation(item: item)
    }
    
    private func setUpView() {
        view.backgroundColor = .systemBackground
        UITabBar.appearance().tintColor = UIColor.label
        UITabBar.appearance().backgroundColor = .systemBackground
    }
    
    private func setUpTabs() {
        // новости
        newsVC.tabBarItem = UITabBarItem(title: "Новости", image: UIImage(named: "mail"), selectedImage: UIImage(named: "mail selected"))
        // расписание
        timetableVC.tabBarItem = UITabBarItem(title: "Расписание", image: UIImage(named: "calendar"), selectedImage: UIImage(named: "calendar selected"))
        // настройки
        settingsVC.tabBarItem = UITabBarItem(title: "Настройки", image: UIImage(named: "settings"), selectedImage: UIImage(named: "settings selected"))
        let nav1VC = UINavigationController(rootViewController: newsVC)
        let nav3VC = UINavigationController(rootViewController: timetableVC)
        let nav4VC = UINavigationController(rootViewController: settingsVC)
        
        let onlyTimetable = UserDefaults.standard.object(forKey: "onOnlyTimetable") as? Bool ?? false
        
        if onlyTimetable {
            setViewControllers([nav3VC, middleButton, nav4VC], animated: false)
        } else {
            // для каждого статуса
            forEveryStatusVC = settingsManager.checkCurrentStatus()
            setViewControllers([nav1VC, forEveryStatusVC, middleButton, nav3VC, nav4VC], animated: false)
            selectedIndex = 0
        }
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
    }
    
    // MARK: - Dynamic Button
    private func createMiddleButton() {
        DynamicButton.setImage(UIImage(named: settingsManager.checkCurrentIcon()), for: .normal)
        DynamicButton.frame = CGRect(x: 0, y: 0, width: 64, height: 64)
        // Устанавливаем положение кнопки по середине TabBar
        DynamicButton.center = CGPoint(x: tabBar.frame.width / 2, y: tabBar.frame.height / 2 - 5)
        // Назначаем действие для кнопки
        DynamicButton.addTarget(self, action: #selector(VoiceCommands), for: .touchUpInside)
        // Добавляем кнопку на TabBar
        tabBar.addSubview(DynamicButton)
    }
    
    // MARK: - Shake To Recall
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if settingsManager.checkShakeToRecallOption() {
            ShakeToRecall(motion: motion)
        } else {
            self.updateDynamicButton(icon: "info icon")
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
                let ok = UIAlertAction(title: "ОК", style: .default)
                self.showAlert(title: "Вы отключили фишку Shake To Recall!", message: "чтобы дальше пользоваться данной фишкой включите ее в настройках.", actions: [ok])
                self.updateDynamicButton(icon: self.settingsManager.checkCurrentIcon())
            }
        }
    }
    
    private func ShakeToRecall(motion: UIEvent.EventSubtype) {
        if motion == .motionShake {
            ShakeToRecall()
        }
    }
    
    private func ShakeToRecall() {
        self.updateDynamicButton(icon: "time.past")
        let vc = RecentMomentsListTableViewController()
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            self.present(navVC, animated: true)
        }
    }
    
    @objc private func VoiceCommands() {
        isRecording = !isRecording
        if isRecording {
            self.updateDynamicButton(icon: "mic")
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
                        self.DynamicButton.sendActions(for: .touchUpInside)
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
            self.updateDynamicButton(icon: self.settingsManager.checkCurrentIcon())
            speechRecognitionManager.cancelSpeechRecognition()
        }
    }
    
    // MARK: - Voice Control
    private func checkVoiceCommands(text: String) {
        if isOpened {
            ChangeSetion(text: text.lowercased())
            ChangeBuilding(text: text.lowercased())
            ScrollWebScreen(text: text.lastWord())
            closeScreen(text: text.lowercased())
        } else {
            searchSection(text: text.lowercased())
            GenerateRandomSection(text: text.lowercased())
            searchSubSection(text: text.lowercased())
            findBuilding(text: text.lowercased())
        }
        turnOfMicrophone(text: text.lowercased())
    }
    
    private func observeForEveryStatus() {
        NotificationCenter.default.addObserver(forName: Notification.Name("for every status selected"), object: nil, queue: .main) { notification in
            if let icon = notification.object as? String {
                self.updateDynamicButton(icon: icon)
            }
        }
    }
    
    private func observeWebScreen() {
        NotificationCenter.default.addObserver(forName: Notification.Name("screen was closed"), object: nil, queue: .main) { _ in
            if self.isRecording {
                if !self.tabBar.isHidden {
                    DispatchQueue.main.async {
                        self.updateDynamicButton(icon: "mic")
                    }
                }
            } else {
                if !self.tabBar.isHidden {
                    self.updateDynamicButton(icon: self.settingsManager.checkCurrentIcon())
                }
            }
        }
    }
    
    // MARK: - Selected Faculty
    private func observeFaculty() {
        NotificationCenter.default.addObserver(forName: Notification.Name("icon"), object: nil, queue: .main) { notification in
            if let icon = notification.object as? String {
                self.updateDynamicButton(icon: icon)
            } else {
                self.updateDynamicButton(icon: "новый год")
            }
        }
    }
    
    // MARK: - Adaptive News
    private func observeArticleSelected() {
        NotificationCenter.default.addObserver(forName: Notification.Name("article selected"), object: nil, queue: .main) { _ in
            self.updateDynamicButton(icon: "info icon")
        }
    }
    
    private func observeDataRefreshed() {
        NotificationCenter.default.addObserver(forName: Notification.Name("refreshed"), object: nil, queue: .main) { _ in
            self.updateDynamicButton(icon: "refresh icon")
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                self.updateDynamicButton(icon: self.settingsManager.checkCurrentIcon())
            }
        }
    }
}
