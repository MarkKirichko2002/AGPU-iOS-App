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
    let timetableVC = TimeTableListTableViewController()
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
            DispatchQueue.main.async {
                self.DynamicButton.setImage(UIImage(named: "info icon"), for: .normal)
                self.animation.SpringAnimation(view: self.DynamicButton)
                HapticsManager.shared.HapticFeedback()
            }
            
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
                let ok = UIAlertAction(title: "ОК", style: .default)
                self.ShowAlert(title: "Вы отключили фишку Shake To Recall!", message: "чтобы дальше пользоваться данной фишкой включите ее в настройках.", actions: [ok])
                DispatchQueue.main.async {
                    self.DynamicButton.setImage(UIImage(named: self.settingsManager.checkCurrentIcon()), for: .normal)
                    self.animation.SpringAnimation(view: self.DynamicButton)
                    HapticsManager.shared.HapticFeedback()
                }
            }
        }
    }
    
    private func ShakeToRecall(motion: UIEvent.EventSubtype) {
        if motion == .motionShake {
            ShakeToRecall()
        }
    }
    
    private func ShakeToRecall() {
        if let page = UserDefaults.loadData(type: RecentPageModel.self, key: "last page") {
            if !self.tabBar.isHidden {
                DispatchQueue.main.async {
                    self.DynamicButton.setImage(UIImage(named: "time.past"), for: .normal)
                    self.animation.SpringAnimation(view: self.DynamicButton)
                    HapticsManager.shared.HapticFeedback()
                }
            }
            if page.url.lowercased().hasSuffix(".pdf") {
                
            } else {
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                    self.ShowRecentPageScreen(page: page)
                }
            }
        }
    }
    
    @objc private func VoiceCommands() {
        isRecording = !isRecording
        if isRecording {
            DispatchQueue.main.async {
                self.DynamicButton.setImage(UIImage(named: "mic"), for: .normal)
                self.animation.SpringAnimation(view: self.DynamicButton)
                HapticsManager.shared.HapticFeedback()
            }
            speechRecognitionManager.startRecognize()
            speechRecognitionManager.registerSpeechRecognitionHandler { text in
                self.checkVoiceCommands(text: text)
            }
        } else {
            DispatchQueue.main.async {
                self.DynamicButton.setImage(UIImage(named: self.settingsManager.checkCurrentIcon()), for: .normal)
                self.animation.SpringAnimation(view: self.DynamicButton)
                HapticsManager.shared.HapticFeedback()
            }
            speechRecognitionManager.cancelSpeechRecognition()
        }
    }
    
    // MARK: - Voice Control
    private func checkVoiceCommands(text: String) {
        
        // MARK: - Screen "News"
        if text != "" && selectedIndex == 0 {
            if text.lowercased().lastWord() == "вверх" {
                DispatchQueue.main.async {
                    self.DynamicButton.setImage(UIImage(named: "arrow.up"), for: .normal)
                    self.animation.SpringAnimation(view: self.DynamicButton)
                    HapticsManager.shared.HapticFeedback()
                }
                NotificationCenter.default.post(name: Notification.Name("ScrollMainScreen"), object: text.lastWord())
            } else if text.lowercased().lastWord() == "вниз" {
                DispatchQueue.main.async {
                    self.DynamicButton.setImage(UIImage(named: "arrow.down"), for: .normal)
                    self.animation.SpringAnimation(view: self.DynamicButton)
                    HapticsManager.shared.HapticFeedback()
                }
                NotificationCenter.default.post(name: Notification.Name("ScrollMainScreen"), object: text.lastWord())
            } else if text.lowercased().lastWord().contains("лево") {
                DispatchQueue.main.async {
                    self.DynamicButton.setImage(UIImage(named: "arrow.left"), for: .normal)
                    self.animation.SpringAnimation(view: self.DynamicButton)
                    HapticsManager.shared.HapticFeedback()
                }
                NotificationCenter.default.post(name: Notification.Name("ScrollMainScreen"), object: text.lastWord())
            } else if text.lowercased().lastWord().contains("право"){
                DispatchQueue.main.async {
                    self.DynamicButton.setImage(UIImage(named: "arrow.right"), for: .normal)
                    self.animation.SpringAnimation(view: self.DynamicButton)
                    HapticsManager.shared.HapticFeedback()
                }
                NotificationCenter.default.post(name: Notification.Name("ScrollMainScreen"), object: text.lastWord())
            }
        }
        
        // MARK: - "Sections"
        if text.lowercased().contains("раздел") {
            
            let vc = AGPUSectionsListViewController()
            let navVC = UINavigationController(rootViewController: vc)
            
            DispatchQueue.main.async {
                self.DynamicButton.setImage(UIImage(named: "sections icon"), for: .normal)
                self.animation.SpringAnimation(view: self.DynamicButton)
            }
            
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                self.present(navVC, animated: true)
            }
            
            // поиск раздела
            for section in AGPUSections.sections {
                
                if text.lastWord().lowercased().contains(section.voiceCommand) {
                    
                    NotificationCenter.default.post(name: Notification.Name("ScrollToSection"), object: section.id)
                    break
                }
            }
        }
        
        if text != "" {
            // поиск подраздела
            for section in AGPUSections.sections {
                
                for subsection in section.subsections {
                    
                    if text.noWhitespacesWord().contains(subsection.voiceCommand) {
                        
                        DispatchQueue.main.async {
                            self.DynamicButton.setImage(UIImage(named: subsection.icon), for: .normal)
                            self.animation.SpringAnimation(view: self.DynamicButton)
                        }
                                                
                        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                            self.GoToWeb(url: subsection.url, title: nil, isSheet: false)
                        }
                    
                        NotificationCenter.default.post(name: Notification.Name("scroll"), object: text.lastWord())
                        break
                    }
                }
            }
        }
        
        // закрыть экран
        if text.lowercased().contains("закр") {
            
            speechRecognitionManager.cancelSpeechRecognition()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.speechRecognitionManager.startRecognize()
                self.DynamicButton.setImage(UIImage(named: "mic"), for: .normal)
                NotificationCenter.default.post(name: Notification.Name("close screen"), object: nil)
            }
        }
        
        // выключить микрофон
        if text.lowercased().contains("стоп") {
            DynamicButton.sendActions(for: .touchUpInside)
        }
    }
    
    private func ObserveForEveryStatus() {
        NotificationCenter.default.addObserver(forName: Notification.Name("for student selected"), object: nil, queue: .main) { notification in
            if let icon = notification.object as? String {
                DispatchQueue.main.async {
                    self.DynamicButton.setImage(UIImage(named: icon), for: .normal)
                    self.animation.SpringAnimation(view: self.DynamicButton)
                    HapticsManager.shared.HapticFeedback()
                }
            }
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name("for student appear"), object: nil, queue: .main) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.DynamicButton.setImage(UIImage(named: self.settingsManager.checkCurrentIcon()), for: .normal)
                self.animation.SpringAnimation(view: self.DynamicButton)
                HapticsManager.shared.HapticFeedback()
            }
        }
    }
    
    private func ObserveWebScreen() {
        NotificationCenter.default.addObserver(forName: Notification.Name("screen was closed"), object: nil, queue: .main) { _ in
            if self.isRecording {
                if !self.tabBar.isHidden {
                    DispatchQueue.main.async {
                        self.DynamicButton.setImage(UIImage(named: "mic"), for: .normal)
                        HapticsManager.shared.HapticFeedback()
                    }
                }
            } else {
                if !self.tabBar.isHidden {
                    DispatchQueue.main.async {
                        self.DynamicButton.setImage(UIImage(named: self.settingsManager.checkCurrentIcon()), for: .normal)
                        self.animation.SpringAnimation(view: self.DynamicButton)
                        HapticsManager.shared.HapticFeedback()
                    }
                }
            }
        }
    }
    
    // MARK: - Elected Faculty
    private func ObserveFaculty() {
        NotificationCenter.default.addObserver(forName: Notification.Name("faculty"), object: nil, queue: .main) { notification in
            if let icon = notification.object as? AGPUFacultyModel {
                DispatchQueue.main.async {
                    self.DynamicButton.setImage(UIImage(named: icon.icon), for: .normal)
                    self.animation.SpringAnimation(view: self.DynamicButton)
                    HapticsManager.shared.HapticFeedback()
                }
            } else {
                DispatchQueue.main.async {
                    self.DynamicButton.setImage(UIImage(named: "АГПУ"), for: .normal)
                    self.animation.SpringAnimation(view: self.DynamicButton)
                    HapticsManager.shared.HapticFeedback()
                }
            }
        }
        NotificationCenter.default.addObserver(forName: Notification.Name("group"), object: nil, queue: .main) { notification in
            
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
                self.DynamicButton.setImage(UIImage(named: "lock"), for: .normal)
                self.animation.SpringAnimation(view: self.DynamicButton)
                HapticsManager.shared.HapticFeedback()
            }
            
            Timer.scheduledTimer(withTimeInterval: 2.5, repeats: false) { _ in
                self.DynamicButton.setImage(UIImage(named: self.settingsManager.checkCurrentIcon()), for: .normal)
                self.animation.SpringAnimation(view: self.DynamicButton)
                HapticsManager.shared.HapticFeedback()
            }
        }
    }
}
