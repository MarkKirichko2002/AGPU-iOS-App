//
//  AGPUTabBarController.swift
//  AGPU
//
//  Created by Марк Киричко on 09.06.2023.
//

import UIKit

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
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        animation.TabBarItemAnimation(item: item)
    }
    
    // Override selectedIndex for Programmatic changes
    override var selectedIndex: Int {
        didSet {
            print(selectedIndex)
        }
    }
    
    private func setUpTabs() {
        // главное
        let mainVC = WebViewController()
        // расписание
        let timetableVC = WebViewController()
        // кнопка
        let middleButton = UIViewController()
        // разделы
        let sectionsVC = AGPUSectionsViewController()
        // карта
        let mapVC = AGPUMapViewController()
        // главное
        mainVC.tabBarItem = UITabBarItem(title: "Главное", image: UIImage(named: "home"), selectedImage: UIImage(named: "home selected"))
        mainVC.navigationItem.title = "Главное"
        mainVC.url = URL(string: "http://test.agpu.net/")
        // расписание
        timetableVC.tabBarItem = UITabBarItem(title: "Расписание", image: UIImage(named: "schedule"), selectedImage: UIImage(named: "schedule selected"))
        timetableVC.navigationItem.title = "Расписание"
        timetableVC.url = URL(string: "http://www.it-institut.ru/SearchString/Index/118")
        // разделы
        sectionsVC.tabBarItem = UITabBarItem(title: "Разделы", image: UIImage(named: "sections"), selectedImage: UIImage(named: "sections selected"))
        // карта
        mapVC.tabBarItem = UITabBarItem(title: "Карта", image: UIImage(systemName: "map"), selectedImage: UIImage(systemName: "map.fill"))
        mapVC.navigationItem.title = "Найти АГПУ"
        let nav1VC = UINavigationController(rootViewController: mainVC)
        let nav2VC = UINavigationController(rootViewController: timetableVC)
        let nav3VC = UINavigationController(rootViewController: sectionsVC)
        let nav4VC = UINavigationController(rootViewController: mapVC)
        
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
        
        if text.lowercased().contains("раздел") {
            selectedIndex = 0
        }
        
        if text != "" && selectedIndex == 2 {
            // поиск раздела
            for section in AGPUSections.sections {
                if text.lowercased().contains(section.voiceCommand) {
                    
                    NotificationCenter.default.post(name: Notification.Name("ScrollToSection"), object: section.id)
                    
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
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            NotificationCenter.default.post(name: Notification.Name("SubSectionSelected"), object: subsection.url)
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
}
