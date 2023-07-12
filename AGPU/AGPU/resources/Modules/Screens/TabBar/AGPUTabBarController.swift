//
//  AGPUTabBarController.swift
//  AGPU
//
//  Created by Марк Киричко on 09.06.2023.
//

import UIKit

class AGPUTabBarController: UITabBarController {
    
    // MARK: - сервисы
    private let speechRecognitionManager = SpeechRecognitionManager()
    private let animation = AnimationClass()
    private let settingsManager = SettingsManager()
    
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
        setUpTabs()
        createMiddleButton()
        ObserveSubSection()
        ObserveWebScreen()
        ObserveMap()
        settingsManager.checkAllSettings()
        ObserveChangeIcon()
        becomeFirstResponder()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        animation.TabBarItemAnimation(item: item)
    }
        
    private func setUpTabs() {
        // главное
        let mainVC = AGPUMainViewController()
        // кнопка
        let middleButton = UIViewController()
        // студенту
        let studentVC = ForStudentListTableViewController()
        // своя музыка
        let sectionsVC = CustomMusicListViewController()
        // настройки
        let settingsVC = SettingsListViewController()
        // главное
        mainVC.tabBarItem = UITabBarItem(title: "Главное", image: UIImage(named: "home"), selectedImage: UIImage(named: "home selected"))
        // студенту
        studentVC.tabBarItem = UITabBarItem(title: "Студенту", image: UIImage(named: "applicant"), selectedImage: UIImage(named: "applicant selected"))
        // своя музыка
        sectionsVC.tabBarItem = UITabBarItem(title: "Своя Музыка", image: UIImage(named: "music"), selectedImage: UIImage(named: "music selected"))
        sectionsVC.navigationItem.title = "Своя Музыка"
        // настройки
        settingsVC.tabBarItem = UITabBarItem(title: "Настройки", image: UIImage(systemName: "gear"), selectedImage: UIImage(systemName: "gear.fill"))
        settingsVC.navigationItem.title = "Настройки"
        let nav1VC = UINavigationController(rootViewController: mainVC)
        let nav2VC = UINavigationController(rootViewController: studentVC)
        let nav3VC = UINavigationController(rootViewController: sectionsVC)
        let nav4VC = UINavigationController(rootViewController: settingsVC)
        
        setViewControllers([nav1VC, nav2VC, middleButton, nav3VC, nav4VC], animated: true)
    }
    
    // MARK: - Dynamic Button
    private func createMiddleButton() {
        DynamicButton.setImage(UIImage(named: settingsManager.checkCurrentIcon() ?? "АГПУ"), for: .normal)
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
        ShakeToRecall(motion: motion)
    }
    
    private func ShakeToRecall(motion: UIEvent.EventSubtype) {
        if motion == .motionShake {
            ShakeToRecall()
        }
    }
    
    private func ShakeToRecall() {
        if let page = UserDefaults.loadData(type: RecentPageModel.self, key: "last page") {
            DispatchQueue.main.async {
                self.DynamicButton.setImage(UIImage(named: "time.past"), for: .normal)
                self.animation.SpringAnimation(view: self.DynamicButton)
                HapticsManager.shared.HapticFeedback()
            }
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                self.ShowRecentPageScreen(page: page)
            }
        }
    }
    
    @objc private func VoiceCommands() {
        isRecording = !isRecording
        if isRecording {
            DynamicButton.setImage(UIImage(named: "mic"), for: .normal)
            animation.SpringAnimation(view: self.DynamicButton)
            HapticsManager.shared.HapticFeedback()
            speechRecognitionManager.startRecognize()
            speechRecognitionManager.registerSpeechRecognitionHandler { text in
                self.checkVoiceCommands(text: text)
            }
        } else {
            DynamicButton.setImage(UIImage(named: settingsManager.checkCurrentIcon() ?? "АГПУ"), for: .normal)
            animation.SpringAnimation(view: self.DynamicButton)
            HapticsManager.shared.HapticFeedback()
            speechRecognitionManager.cancelSpeechRecognition()
        }
    }
    
    // MARK: - Voice Control
    private func checkVoiceCommands(text: String) {
        
        // MARK: - Screen "Main"
        if text != "" && selectedIndex == 0 {
            
            if text.lowercased().lastWord() == "вверх" {
                DispatchQueue.main.async {
                    self.DynamicButton.setImage(UIImage(named: "arrow.up"), for: .normal)
                    self.animation.SpringAnimation(view: self.DynamicButton)
                    HapticsManager.shared.HapticFeedback()
                }
            } else if text.lowercased().lastWord() == "вниз" {
                DispatchQueue.main.async {
                    self.DynamicButton.setImage(UIImage(named: "arrow.down"), for: .normal)
                    self.animation.SpringAnimation(view: self.DynamicButton)
                    HapticsManager.shared.HapticFeedback()
                }
            } else if text.lowercased().lastWord().contains("лево") {
                DispatchQueue.main.async {
                    self.DynamicButton.setImage(UIImage(named: "arrow.left"), for: .normal)
                    self.animation.SpringAnimation(view: self.DynamicButton)
                    HapticsManager.shared.HapticFeedback()
                }
            } else if text.lowercased().lastWord().contains("право"){
                DispatchQueue.main.async {
                    self.DynamicButton.setImage(UIImage(named: "arrow.right"), for: .normal)
                    self.animation.SpringAnimation(view: self.DynamicButton)
                    HapticsManager.shared.HapticFeedback()
                }
            }
            NotificationCenter.default.post(name: Notification.Name("ScrollMainScreen"), object: text.lastWord())
        }
        
        // MARK: - Screen "Sections"
        if text != "" && selectedIndex == 1 {
            // поиск раздела
            for section in AGPUSections.sections {
                
                if text.lowercased().contains(section.voiceCommand) {
                    
                    NotificationCenter.default.post(name: Notification.Name("ScrollToSection"), object: section.id)
                    
                    DispatchQueue.main.async {
                        self.DynamicButton.setImage(UIImage(named: section.icon), for: .normal)
                        self.animation.SpringAnimation(view: self.DynamicButton)
                    }
                    
                    speechRecognitionManager.cancelSpeechRecognition()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.speechRecognitionManager.startRecognize()
                    }
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
                            self.GoToWeb(url: subsection.url, title: nil)
                        }
                    
                        NotificationCenter.default.post(name: Notification.Name("scroll"), object: text.lastWord())
                    }
                }
            }
        }
        
        if text.lowercased().contains("расписан") {
            let vc = TimeTableListTableViewController()
            let navVC = UINavigationController(rootViewController: vc)
            present(navVC, animated: true)
        }
        
        // закрыть экран
        if text.lowercased().contains("закр") {
            
            speechRecognitionManager.cancelSpeechRecognition()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.speechRecognitionManager.startRecognize()
                self.DynamicButton.setImage(UIImage(named: "mic"), for: .normal)
                self.dismiss(animated: true)
            }
        }
        
        // выключить микрофон
        if text.lowercased().contains("стоп") {
            DynamicButton.sendActions(for: .touchUpInside)
        }
    }
    
    private func ObserveSubSection() {
        NotificationCenter.default.addObserver(forName: Notification.Name("subsection"), object: nil, queue: .main) { notification in
            if let subsection = notification.object as? AGPUSubSectionModel {
                self.DynamicButton.setImage(UIImage(named: subsection.icon), for: .normal)
                self.animation.SpringAnimation(view: self.DynamicButton)
                HapticsManager.shared.HapticFeedback()
            }
        }
    }
    
    private func ObserveWebScreen() {
        NotificationCenter.default.addObserver(forName: Notification.Name("WebScreenWasClosed"), object: nil, queue: .main) { _ in
            if self.isRecording {
                self.DynamicButton.setImage(UIImage(named: "mic"), for: .normal)
                HapticsManager.shared.HapticFeedback()
            } else {
                self.DynamicButton.setImage(UIImage(named: self.settingsManager.checkCurrentIcon() ?? "АГПУ"), for: .normal)
                self.animation.SpringAnimation(view: self.DynamicButton)
                HapticsManager.shared.HapticFeedback()
            }
        }
    }
    
    private func ObserveMap() {
        NotificationCenter.default.addObserver(forName: Notification.Name("Map Pin Selected"), object: nil, queue: .main) { _ in
            DispatchQueue.main.async {
                self.DynamicButton.setImage(UIImage(named: "pin"), for: .normal)
                self.animation.SpringAnimation(view: self.DynamicButton)
                HapticsManager.shared.HapticFeedback()
            }
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name("Go To Map"), object: nil, queue: .main) { _ in
            DispatchQueue.main.async {
                self.DynamicButton.setImage(UIImage(named: "map icon"), for: .normal)
                self.animation.SpringAnimation(view: self.DynamicButton)
                HapticsManager.shared.HapticFeedback()
            }
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name("Map Was Opened"), object: nil, queue: .main) { _ in
            if self.isRecording {
                self.DynamicButton.setImage(UIImage(named: "mic"), for: .normal)
                HapticsManager.shared.HapticFeedback()
            } else {
                self.DynamicButton.setImage(UIImage(named: self.settingsManager.checkCurrentIcon() ?? "АГПУ"), for: .normal)
                self.animation.SpringAnimation(view: self.DynamicButton)
                HapticsManager.shared.HapticFeedback()
            }
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name("Map Pin Cancelled"), object: nil, queue: .main) { _ in
            if self.isRecording {
                self.DynamicButton.setImage(UIImage(named: "mic"), for: .normal)
                HapticsManager.shared.HapticFeedback()
            } else {
                self.DynamicButton.setImage(UIImage(named: self.settingsManager.checkCurrentIcon() ?? "АГПУ"), for: .normal)
                self.animation.SpringAnimation(view: self.DynamicButton)
                HapticsManager.shared.HapticFeedback()
            }
        }
    }
    
    // MARK: - Elected Faculty
    private func ObserveChangeIcon() {
        NotificationCenter.default.addObserver(forName: Notification.Name("icon"), object: nil, queue: .main) { notification in
            if let icon = notification.object as? AGPUFacultyModel {
                self.DynamicButton.setImage(UIImage(named: icon.icon), for: .normal)
                self.animation.SpringAnimation(view: self.DynamicButton)
                HapticsManager.shared.HapticFeedback()
            }
        }
    }
}
