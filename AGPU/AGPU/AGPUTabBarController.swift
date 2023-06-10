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
    
    let favouritesVC = UIViewController()
    let middleButton = UIViewController()
    let sectionsVC = AGPUSectionsViewController()
    
    private var isRecording = false
    private let speechRecognitionManager = SpeechRecognitionManager()
    private let animation = AnimationClass()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        UITabBar.appearance().tintColor = UIColor.black
        setUpTabs()
        createMiddleButton()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        animation.TabBarItemAnimation(item: item)
    }
    

    // Override selectedIndex for Programmatic changes
    override var selectedIndex: Int {
        didSet {
            print("")
        }
    }
    
    private func setUpTabs() {
        sectionsVC.delegate = self
        
        favouritesVC.tabBarItem = UITabBarItem(title: "Избранное", image: UIImage(systemName: "star"), selectedImage: UIImage(systemName: "star.fill"))
        sectionsVC.tabBarItem = UITabBarItem(title: "Главное", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        
        setViewControllers([favouritesVC, middleButton, sectionsVC], animated: true)
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
            selectedIndex = 2
        }
        
        if text != "" && selectedIndex == 2 {
            // поиск раздела
            for section in AGPUSections.sections {
                if text.lowercased().contains(section.voiceCommand) {
                    sectionsVC.tableView.scrollToRow(at: IndexPath(row: 0, section: section.id), at: .top, animated: true)
                    
                    speechRecognitionManager.cancelSpeechRecognition()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.speechRecognitionManager.startSpeechRecognition()
                    }
                } else {
                    print(text)
                }
            }
        }
        
        if text != "" {
            // поиск подраздела
            for section in AGPUSections.sections {
                for subsection in section.subsections {
                    if text.lowercased().contains(subsection.voiceCommand) {
                        self.sectionsVC.GoToWeb(url: subsection.url)
                    } else {
                        print(text)
                    }
                }
            }
        }
        
        // закрыть экран
        if text.lowercased().contains("закр") {
            
            speechRecognitionManager.cancelSpeechRecognition()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.speechRecognitionManager.startSpeechRecognition()
                self.dismiss(animated: true)
            }
        }
        
        // выключить микрофон
        if text.lowercased().contains("стоп") {
            button.sendActions(for: .touchUpInside)
        }
    }
}

// MARK: - AGPUSectionsViewControllerDelegate
extension AGPUTabBarController: AGPUSectionsViewControllerDelegate {
    
    func subSectionWasSelected(subSection: AGPUSubSectionModel) {
        animation.SpringAnimation(view: self.button)
    }
}
