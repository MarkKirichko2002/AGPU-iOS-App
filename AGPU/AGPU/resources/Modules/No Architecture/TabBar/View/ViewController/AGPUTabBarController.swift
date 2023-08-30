//
//  AGPUTabBarController.swift
//  AGPU
//
//  Created by Марк Киричко on 09.06.2023.
//

import UIKit

final class AGPUTabBarController: UITabBarController {
    
    // MARK: - сервисы
    private let speechRecognitionManager = SpeechRecognitionManager()
    private let animation = AnimationClass()
    private let settingsManager = SettingsManager()
    
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
    
    private var isRecording = false
    
    // MARK: - Dynamic Button
    private let DynamicButton: UIButton = {
        let button = UIButton()
        button.imageView?.tintColor = .black
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
        observeNewsRefreshed()
        becomeFirstResponder()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        animation.TabBarItemAnimation(item: item)
    }
    
    private func setUpView() {
        view.backgroundColor = .systemBackground
        UITabBar.appearance().tintColor = UIColor.black
        UITabBar.appearance().backgroundColor = UIColor.white
    }
    
    private func setUpTabs() {
        // новости
        newsVC.tabBarItem = UITabBarItem(title: "Новости", image: UIImage(named: "mail"), selectedImage: UIImage(named: "mail selected"))
        // для каждого статуса
        forEveryStatusVC = settingsManager.checkCurrentStatus()
        // расписание
        timetableVC.tabBarItem = UITabBarItem(title: "Расписание", image: UIImage(named: "calendar"), selectedImage: UIImage(named: "calendar selected"))
        // настройки
        settingsVC.tabBarItem = UITabBarItem(title: "Настройки", image: UIImage(named: "settings"), selectedImage: UIImage(named: "settings selected"))
        let nav1VC = UINavigationController(rootViewController: newsVC)
        let nav3VC = UINavigationController(rootViewController: timetableVC)
        let nav4VC = UINavigationController(rootViewController: settingsVC)
        setViewControllers([nav1VC, forEveryStatusVC, middleButton, nav3VC, nav4VC], animated: false)
    }
    
    private func setUpTab() {
        settingsManager.ObserveStatusChanged {
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
                self.ShowAlert(title: "Вы отключили фишку Shake To Recall!", message: "чтобы дальше пользоваться данной фишкой включите ее в настройках.", actions: [ok])
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
                    let settingsAction = UIAlertAction(title: "перейти в настройки", style: .default) { _ in
                        self.OpenSettings()
                    }
                    let cancel = UIAlertAction(title: "отмена", style: .default) { _ in
                        self.DynamicButton.sendActions(for: .touchUpInside)
                    }
                    self.ShowAlert(title: "Микрофон выключен", message: "хотите включить в настройках?", actions: [settingsAction, cancel])
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
        searchSection(text: text.lowercased())
        GenerateRandomSection(text: text.lowercased())
        searchSubSection(text: text.lowercased())
        findBuilding(text: text.lowercased())
        closeScreen(text: text.lowercased())
        turnOfMicrophone(text: text.lowercased())
        ScrollWebScreen(text: text.lastWord())
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
    
    // MARK: - Elected Faculty
    private func observeFaculty() {
        NotificationCenter.default.addObserver(forName: Notification.Name("icon"), object: nil, queue: .main) { notification in
            if let icon = notification.object as? String {
                self.updateDynamicButton(icon: icon)
            } else {
                self.updateDynamicButton(icon: "АГПУ")
            }
        }
        NotificationCenter.default.addObserver(forName: Notification.Name("group"), object: nil, queue: .main) { notification in
            
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
                self.updateDynamicButton(icon: "lock")
            }
            
            Timer.scheduledTimer(withTimeInterval: 2.5, repeats: false) { _ in
                self.updateDynamicButton(icon: self.settingsManager.checkCurrentIcon())
            }
        }
    }
    
    // MARK: - Adaptive News
    private func observeArticleSelected() {
        NotificationCenter.default.addObserver(forName: Notification.Name("article selected"), object: nil, queue: .main) { _ in
            self.updateDynamicButton(icon: "info icon")
        }
    }
    
    private func observeNewsRefreshed() {
        NotificationCenter.default.addObserver(forName: Notification.Name("news refreshed"), object: nil, queue: .main) { _ in
            self.updateDynamicButton(icon: "refresh icon")
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                self.updateDynamicButton(icon: self.settingsManager.checkCurrentIcon())
            }
        }
    }
}

extension AGPUTabBarController {
    
    // поиск раздела
    func searchSection(text: String) {
        
        for section in AGPUSections.sections {
            
            if text.lowercased().contains(section.voiceCommand) {
                
                self.updateDynamicButton(icon: section.icon)
                
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                    self.GoToWeb(url: section.url, image: section.icon, title: section.name, isSheet: false)
                }
                ResetSpeechRecognition()
                break
            }
        }
    }
    
    // случайный раздел
    func GenerateRandomSection(text: String) {
        
        if text.lowercased().contains("случайный раздел") || text.lowercased().contains("случайно раздел") || text.lowercased().contains("рандомный раздел") || text.lowercased().contains("рандомно раздел") {
            
            let section = AGPUSections.sections[Int.random(in: 0..<AGPUSections.sections.count - 1)]
            
            self.updateDynamicButton(icon: "dice")
            
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                self.GoToWeb(url: section.url, image: section.icon, title: section.name, isSheet: false)
            }
            ResetSpeechRecognition()
        }
    }
    
    // поиск подраздела
    func searchSubSection(text: String) {
        
        for section in AGPUSections.sections {
            
            for subsection in section.subsections {
                
                if text.noWhitespacesWord().contains(subsection.voiceCommand) && subsection.url != "" {
                    ResetSpeechRecognition()
                    self.updateDynamicButton(icon: subsection.icon)
                    
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                        self.GoToWeb(url: subsection.url, image: subsection.icon, title: "ФГБОУ ВО «АГПУ»", isSheet: false)
                    }
                    break
                }
            }
        }
    }
    
    // поиск корпуса
    func findBuilding(text: String) {
        
        for building in AGPUBuildings.buildings {
            
            if building.voiceCommands.contains(where: { text.lowercased().range(of: $0.lowercased()) != nil }) {
                ResetSpeechRecognition()
                self.updateDynamicButton(icon: "map icon")
                let vc = SearchAGPUBuildingMapViewController(building: building)
                let navVC = UINavigationController(rootViewController: vc)
                navVC.modalPresentationStyle = .fullScreen
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                    self.present(navVC, animated: true)
                }
                break
            }
        }
    }
    
    // закрыть экран
    func closeScreen(text: String) {
        
        if text.lowercased().contains("закр") {
            
            self.ResetSpeechRecognition()
            
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                self.updateDynamicButton(icon: "mic")
                NotificationCenter.default.post(name: Notification.Name("close screen"), object: nil)
            }
        }
    }
    
    func ResetSpeechRecognition() {
        speechRecognitionManager.cancelSpeechRecognition()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.speechRecognitionManager.startRecognize()
        }
    }
    
    // выключить микрофон
    func turnOfMicrophone(text: String) {
        
        if text.lowercased().contains("стоп") {
            
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                NotificationCenter.default.post(name: Notification.Name("close screen"), object: nil)
            }
            
            self.DynamicButton.sendActions(for: .touchUpInside)
            
        }
    }
    
    // прокрутка веб страницы
    func ScrollWebScreen(text: String) {
        for direction in VoiceDirections.directions {
            if direction.name.contains(text.lastWord()) {
                NotificationCenter.default.post(name: Notification.Name("scroll web page"), object: text.lastWord())
            }
        }
    }
    
    // изменение Dynamic Button
    func updateDynamicButton(icon: String) {
        DispatchQueue.main.async {
            self.DynamicButton.setImage(UIImage(named: icon), for: .normal)
            self.animation.SpringAnimation(view: self.DynamicButton)
            HapticsManager.shared.HapticFeedback()
        }
    }
}
