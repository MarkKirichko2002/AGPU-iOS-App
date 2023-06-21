//
//  AGPUTabBarController.swift
//  AGPU
//
//  Created by Марк Киричко on 09.06.2023.
//

import UIKit
import AVFoundation

class AGPUTabBarController: UITabBarController {
    
    private let button: UIButton = {
        let button = UIButton()
        button.imageView?.tintColor = .black
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.cornerRadius = button.frame.width / 2
        button.clipsToBounds = true
        return button
    }()
    
    private var isRecording = false
    private let speechRecognitionManager = SpeechRecognitionManager()
    private let animation = AnimationClass()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        UITabBar.appearance().tintColor = UIColor.black
        setUpTabs()
        createMiddleButton()
        ObserveSubSection()
        ObserveWebScreen()
        checkRelaxModeSetting()
        ObserveRelaxMode()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        animation.TabBarItemAnimation(item: item)
    }
    
    override var selectedIndex: Int {
        didSet {
            print(selectedIndex)
        }
    }
    
    private func setUpTabs() {
        // главное
        let mainVC = WebViewController(url: URL(string: "http://test.agpu.net/")!)
        // кнопка
        let middleButton = UIViewController()
        // разделы
        let sectionsVC = AGPUSectionsViewController()
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
    
    private func createMiddleButton() {
        button.frame = CGRect.init(x: self.tabBar.center.x - 32, y: self.view.bounds.height - 90, width: 64, height: 64)
        button.layer.cornerRadius = 33
        button.setImage(UIImage(named: "АГПУ"), for: .normal)
        self.view.insertSubview(button, aboveSubview: self.tabBar)
        button.addTarget(self, action:  #selector(AGPUTabBarController.VoiceCommands), for: .touchUpInside)
    }
    
    @objc private func VoiceCommands() {
        isRecording = !isRecording
        if isRecording {
            button.setImage(UIImage(named: "mic"), for: .normal)
            animation.SpringAnimation(view: self.button)
            speechRecognitionManager.startSpeechRecognition()
            speechRecognitionManager.registerSpeechRecognitionHandler { text in
                self.checkVoiceCommands(text: text)
            }
        } else {
            button.setImage(UIImage(named: "АГПУ"), for: .normal)
            animation.SpringAnimation(view: self.button)
            speechRecognitionManager.cancelSpeechRecognition()
        }
    }
    
    private func checkVoiceCommands(text: String) {
        
        if text != "" && selectedIndex == 1 {
            // поиск раздела
            for section in AGPUSections.sections {
                
                if text.lowercased().contains(section.voiceCommand) {
                    
                    NotificationCenter.default.post(name: Notification.Name("ScrollToSection"), object: section.id)
                    
                    DispatchQueue.main.async {
                        self.button.setImage(UIImage(named: section.icon), for: .normal)
                        self.animation.SpringAnimation(view: self.button)
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
                            self.button.setImage(UIImage(named: subsection.icon), for: .normal)
                            self.animation.SpringAnimation(view: self.button)
                        }
                        
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
                self.button.setImage(UIImage(named: "mic"), for: .normal)
                self.dismiss(animated: true)
            }
        }
        
        // выключить микрофон
        if text.lowercased().contains("стоп") {
            button.sendActions(for: .touchUpInside)
        }
    }
    
    private func ObserveSubSection() {
        NotificationCenter.default.addObserver(forName: Notification.Name("subsection"), object: nil, queue: .main) { notification in
            if let subsection = notification.object as? AGPUSubSectionModel {
                self.button.setImage(UIImage(named: subsection.icon), for: .normal)
                self.animation.SpringAnimation(view: self.button)
            }
        }
    }
    
    private func ObserveWebScreen() {
        NotificationCenter.default.addObserver(forName: Notification.Name("WebScreenWasClosed"), object: nil, queue: .main) { _ in
            self.button.setImage(UIImage(named: "АГПУ"), for: .normal)
        }
    }
    
    private func checkRelaxModeSetting() {
        let music = UserDefaults.loadData()
        if music?.isChecked == true {
            AudioPlayer.shared.PlaySound(resource: music?.fileName ?? "")
        }
    }
    
    private func ObserveRelaxMode() {
        NotificationCenter.default.addObserver(forName: Notification.Name("music"), object: nil, queue: .main) { notification in
            if let music = notification.object as? MusicModel {
                if music.isChecked {
                    AudioPlayer.shared.PlaySound(resource: music.fileName)
                } else {
                    AudioPlayer.shared.StopSound(resource: music.fileName)
                    self.button.setImage(UIImage(named: "АГПУ"), for: .normal)
                    self.animation.StopRotateAnimation(view: self.button)
                }
            }
        }
    }
}
