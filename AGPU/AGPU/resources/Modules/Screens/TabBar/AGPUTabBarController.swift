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
        settingsManager.checkAllSettings()
        ObserveRelaxMode()
        becomeFirstResponder()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        animation.TabBarItemAnimation(item: item)
    }
        
    private func setUpTabs() {
        // главное
        let mainVC = WebViewController(url: URL(string: "http://test.agpu.net/")!)
        // кнопка
        let middleButton = UIViewController()
        // разделы
        let sectionsVC = AGPUSectionsListViewController()
        // карта
        let mapVC = MapRealisationsListViewController()
        // настройки
        let settingsVC = SettingsListViewController()
        // главное
        mainVC.tabBarItem = UITabBarItem(title: "Главное", image: UIImage(named: "home"), selectedImage: UIImage(named: "home selected"))
        mainVC.navigationItem.title = "Главное"
        // разделы
        sectionsVC.tabBarItem = UITabBarItem(title: "Разделы", image: UIImage(named: "sections"), selectedImage: UIImage(named: "sections selected"))
        // карта
        mapVC.tabBarItem = UITabBarItem(title: "Карты", image: UIImage(named: "map"), selectedImage: UIImage(named: "map selected"))
        mapVC.navigationItem.title = "Карты"
        // настройки
        settingsVC.tabBarItem = UITabBarItem(title: "Настройки", image: UIImage(systemName: "gear"), selectedImage: UIImage(systemName: "gear.fill"))
        settingsVC.navigationItem.title = "Настройки"
        let nav1VC = UINavigationController(rootViewController: mainVC)
        let nav2VC = UINavigationController(rootViewController: sectionsVC)
        let nav3VC = UINavigationController(rootViewController: mapVC)
        let nav4VC = UINavigationController(rootViewController: settingsVC)
        
        setViewControllers([nav1VC, nav2VC, middleButton, nav3VC, nav4VC], animated: true)
    }
    
    // MARK: - Dynamic Button
    private func createMiddleButton() {
        DynamicButton.setImage(UIImage(named: "АГПУ"), for: .normal)
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
    
    private func ShakeToRecall() {
        if let subsection = UserDefaults.loadData(type: AGPUSubSectionModel.self, key: "lastSubsection") {
            DispatchQueue.main.async {
                self.DynamicButton.setImage(UIImage(named: "time.past"), for: .normal)
                self.animation.SpringAnimation(view: self.DynamicButton)
            }
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                self.GoToWeb(url: subsection.url)
            }
        }
    }
    
    private func ShakeToRecall(motion: UIEvent.EventSubtype) {
        if motion == .motionShake {
            ShakeToRecall()
        }
    }
    
    @objc private func VoiceCommands() {
        isRecording = !isRecording
        if isRecording {
            DynamicButton.setImage(UIImage(named: "mic"), for: .normal)
            animation.SpringAnimation(view: self.DynamicButton)
            speechRecognitionManager.startSpeechRecognition()
            speechRecognitionManager.registerSpeechRecognitionHandler { text in
                self.checkVoiceCommands(text: text)
            }
        } else {
            DynamicButton.setImage(UIImage(named: "АГПУ"), for: .normal)
            animation.SpringAnimation(view: self.DynamicButton)
            speechRecognitionManager.cancelSpeechRecognition()
        }
    }
    
    // MARK: - Voice Control
    private func checkVoiceCommands(text: String) {
        
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
                        self.speechRecognitionManager.startSpeechRecognition()
                    }
                }
            }
        }
        
        if text != "" {
            // поиск подраздела
            for section in AGPUSections.sections {
                
                for subsection in section.subsections {
                    
                    if text.lowercased().contains(subsection.voiceCommand) {
                        
                        DispatchQueue.main.async {
                            self.DynamicButton.setImage(UIImage(named: subsection.icon), for: .normal)
                            self.animation.SpringAnimation(view: self.DynamicButton)
                        }
                                                
                        UserDefaults.SaveData(object: subsection, key: "lastSubsection")
                        
                        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                            self.GoToWeb(url: subsection.url)
                        }
                    
                        NotificationCenter.default.post(name: Notification.Name("scroll"), object: text.lastWord())
                    }
                }
            }
        }
        
        // закрыть экран
        if text.lowercased().contains("закр") {
            
            speechRecognitionManager.cancelSpeechRecognition()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.speechRecognitionManager.startSpeechRecognition()
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
            }
        }
    }
    
    private func ObserveWebScreen() {
        NotificationCenter.default.addObserver(forName: Notification.Name("WebScreenWasClosed"), object: nil, queue: .main) { _ in
            if self.isRecording {
                self.DynamicButton.setImage(UIImage(named: "mic"), for: .normal)
            } else {
                self.DynamicButton.setImage(UIImage(named: "АГПУ"), for: .normal)
            }
        }
    }
    
    private func ObserveRelaxMode() {
        NotificationCenter.default.addObserver(forName: Notification.Name("music"), object: nil, queue: .main) { notification in
            if let music = notification.object as? MusicModel {
                if music.isChecked {
                    AudioPlayer.shared.PlaySound(resource: music.fileName)
                } else {
                    AudioPlayer.shared.StopSound(resource: music.fileName)
                }
            }
        }
    }
}
