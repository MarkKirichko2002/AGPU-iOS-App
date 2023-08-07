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
    let newsVC = AGPUNewsViewController()
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
        view.backgroundColor = .systemBackground
        UITabBar.appearance().tintColor = UIColor.black
        UITabBar.appearance().backgroundColor = UIColor.white
        setUpTabs()
        SetUpTab()
        createMiddleButton()
        ObserveForEveryStatus()
        ObserveWebScreen()
        ObserveFaculty()
        becomeFirstResponder()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        animation.TabBarItemAnimation(item: item)
    }
    
    private func setUpTabs() {
        // новости
        newsVC.tabBarItem = UITabBarItem(title: "Новости", image: UIImage(systemName: "newspaper"), selectedImage: UIImage(systemName: "newspaper.fill"))
        // для каждого статуса
        forEveryStatusVC = settingsManager.checkCurrentStatus()
        // расписание
        timetableVC.tabBarItem = UITabBarItem(title: "Расписание", image: UIImage(named: "calendar"), selectedImage: UIImage(named: "calendar selected"))
        // настройки
        settingsVC.tabBarItem = UITabBarItem(title: "Настройки", image: UIImage(systemName: "gear"), selectedImage: UIImage(systemName: "gear.fill"))
        settingsVC.navigationItem.title = "Настройки"
        let nav1VC = UINavigationController(rootViewController: newsVC)
        let nav3VC = UINavigationController(rootViewController: timetableVC)
        let nav4VC = UINavigationController(rootViewController: settingsVC)
        setViewControllers([nav1VC, forEveryStatusVC, middleButton, nav3VC, nav4VC], animated: false)
    }
    
    private func SetUpTab() {
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
            self.displayDynamicButton(icon: "info icon")
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
                let ok = UIAlertAction(title: "ОК", style: .default)
                self.ShowAlert(title: "Вы отключили фишку Shake To Recall!", message: "чтобы дальше пользоваться данной фишкой включите ее в настройках.", actions: [ok])
                self.displayDynamicButton(icon: self.settingsManager.checkCurrentIcon())
            }
        }
    }
    
    private func ShakeToRecall(motion: UIEvent.EventSubtype) {
        if motion == .motionShake {
            ShakeToRecall()
        }
    }
    
    private func ShakeToRecall() {
        let vc = RecentMomentsViewController()
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
    
    @objc private func VoiceCommands() {
        isRecording = !isRecording
        if isRecording {
            self.displayDynamicButton(icon: "mic")
            speechRecognitionManager.startRecognize()
            speechRecognitionManager.registerSpeechRecognitionHandler { text in
                self.checkVoiceCommands(text: text)
            }
        } else {
            self.displayDynamicButton(icon: self.settingsManager.checkCurrentIcon())
            speechRecognitionManager.cancelSpeechRecognition()
        }
    }
    
    // MARK: - Voice Control
    private func checkVoiceCommands(text: String) {
        
        // MARK: - Screen "News"
        if text != "" && selectedIndex == 0 {
            for direction in VoiceDirections.directions {
                if direction.name.contains(text.lastWord()) {
                    self.displayDynamicButton(icon: direction.icon)
                    NotificationCenter.default.post(name: Notification.Name("scroll news screen"), object: text.lastWord())
                }
            }
        }
        
        if text != "" {
            // поиск раздела
            for section in AGPUSections.sections {
                
                if text.lowercased().contains(section.voiceCommand) {
                    
                    self.displayDynamicButton(icon: section.icon)
                    
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                        self.GoToWeb(url: section.url, title: section.name, isSheet: false)
                    }
                    
                    NotificationCenter.default.post(name: Notification.Name("scroll"), object: text.lastWord())
                    break
                }
            }
        }
        
        // случайны раздел
        if text.lowercased().contains("случайный раздел") || text.lowercased().contains("случайно раздел") || text.lowercased().contains("рандомный раздел") || text.lowercased().contains("рандомно раздел") {
            
            let section = AGPUSections.sections[Int.random(in: 0..<AGPUSections.sections.count - 1)]
            
            self.displayDynamicButton(icon: "dice")
            
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                self.GoToWeb(url: section.url, title: section.name, isSheet: false)
            }
            
            NotificationCenter.default.post(name: Notification.Name("scroll"), object: text.lastWord())
        }
        
        
        if text != "" {
            // поиск подраздела
            for section in AGPUSections.sections {
                
                for subsection in section.subsections {
                    
                    if text.noWhitespacesWord().contains(subsection.voiceCommand) {
                        
                        self.displayDynamicButton(icon: subsection.icon)
                        
                        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                            self.GoToWeb(url: subsection.url, title: "ФГБОУ ВО «АГПУ»", isSheet: false)
                        }
                        
                        for direction in VoiceDirections.directions {
                            if direction.name.contains(text.lastWord()) {
                                NotificationCenter.default.post(name: Notification.Name("scroll web page"), object: text.lastWord())
                            }
                        }
                        break
                    }
                }
            }
        }
        
        if text != "" {
            // поиск корпуса
            for building in AGPUBuildings.buildings {
                
                if building.voiceCommands.contains(where: { text.lowercased().range(of: $0.lowercased()) != nil }) {
                    
                    let vc = SearchAGPUBuildingMapViewController(building: building)
                    let navVC = UINavigationController(rootViewController: vc)
                    navVC.modalPresentationStyle = .fullScreen
                    DispatchQueue.main.async {
                        self.present(navVC, animated: true)
                    }
                    break
                }
            }
        }
        
        // закрыть экран
        if text.lowercased().contains("закр") {
            
            speechRecognitionManager.cancelSpeechRecognition()
            
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                self.speechRecognitionManager.startRecognize()
                self.displayDynamicButton(icon: "mic")
                NotificationCenter.default.post(name: Notification.Name("close screen"), object: nil)
            }
        }
        
        // выключить микрофон
        if text.lowercased().contains("стоп") {
            
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                NotificationCenter.default.post(name: Notification.Name("close screen"), object: nil)
            }
            
            self.DynamicButton.sendActions(for: .touchUpInside)
            
        }
    }
    
    private func ObserveForEveryStatus() {
        NotificationCenter.default.addObserver(forName: Notification.Name("for student selected"), object: nil, queue: .main) { notification in
            if let icon = notification.object as? String {
                self.displayDynamicButton(icon: icon)
            }
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name("for every status appear"), object: nil, queue: .main) { _ in
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                self.displayDynamicButton(icon: self.settingsManager.checkCurrentIcon())
            }
        }
    }
    
    private func ObserveWebScreen() {
        NotificationCenter.default.addObserver(forName: Notification.Name("screen was closed"), object: nil, queue: .main) { _ in
            if self.isRecording {
                if !self.tabBar.isHidden {
                    DispatchQueue.main.async {
                        self.displayDynamicButton(icon: "mic")
                    }
                }
            } else {
                if !self.tabBar.isHidden {
                    self.displayDynamicButton(icon: self.settingsManager.checkCurrentIcon())
                }
            }
        }
    }
    
    // MARK: - Elected Faculty
    private func ObserveFaculty() {
        NotificationCenter.default.addObserver(forName: Notification.Name("faculty"), object: nil, queue: .main) { notification in
            if let icon = notification.object as? AGPUFacultyModel {
                self.displayDynamicButton(icon: icon.icon)
            } else {
                self.displayDynamicButton(icon: "АГПУ")
            }
        }
        NotificationCenter.default.addObserver(forName: Notification.Name("group"), object: nil, queue: .main) { notification in
            
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
                self.displayDynamicButton(icon: "lock")
            }
            
            Timer.scheduledTimer(withTimeInterval: 2.5, repeats: false) { _ in
                self.displayDynamicButton(icon: self.settingsManager.checkCurrentIcon())
            }
        }
    }
}

extension AGPUTabBarController {
    
    func displayDynamicButton(icon: String) {
        DispatchQueue.main.async {
            self.DynamicButton.setImage(UIImage(named: icon), for: .normal)
            self.animation.SpringAnimation(view: self.DynamicButton)
            HapticsManager.shared.HapticFeedback()
        }
    }
}
