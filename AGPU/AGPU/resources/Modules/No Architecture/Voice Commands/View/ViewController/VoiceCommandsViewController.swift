//
//  VoiceCommandsViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 25.11.2024.
//

import UIKit

final class VoiceCommandsViewController: UIViewController {
    
    // MARK: - UI
    private var closeButton: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.tintColor = .label
        imageView.image = UIImage(named: "cross")
        return imageView
    }()
    
    private var infoButton: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.tintColor = .label
        imageView.image = UIImage(named: "info")
        return imageView
    }()
    
    private let commandIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .gray
        imageView.image = UIImage(named: "mic")
        return imageView
    }()
    
    private let commandTitle: UILabel = {
        let label = UILabel()
        label.text = "Команда"
        label.textColor = .gray
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let commandDescription: UILabel = {
        let label = UILabel()
        label.text = "Микрофон выключен"
        label.textColor = .gray
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let turnMicrophoneButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.setTitle("Включить", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .black)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    // MARK: - сервисы
    private let speechRecognitionManager = SpeechRecognitionManager()
    private let settingsManager = SettingsManager()
    private let animation = AnimationClass()
    
    var isRecording = false
    var isOpened = false
    var isAction = false
    weak var delegate: ScreenClosedDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpConstraints()
        checkStartRecording()
        observeScreen()
    }
    
    private func setUpView() {
        view.backgroundColor = .systemBackground
        view.addSubviews(closeButton, infoButton, commandIcon, commandTitle, commandDescription, turnMicrophoneButton)
        turnMicrophoneButton.addTarget(self, action: #selector(turnMicrophone), for: .touchUpInside)
        setUpTaps()
    }
    
    private func setUpTaps() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeScreen))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(showCommandsList))
        closeButton.addGestureRecognizer(tap)
        infoButton.addGestureRecognizer(tap2)
    }
    
    @objc private func closeScreen() {
        delegate?.screenWasClosed()
        speechRecognitionManager.cancelSpeechRecognition()
        HapticsManager.shared.hapticFeedback()
        dismiss(animated: true)
    }
    
    @objc private func showCommandsList() {
        let vc = VoiceCommandsListTableViewController(type: .main)
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
    
    @objc private func turnMicrophone() {
        isRecording = !isRecording
        if isRecording {
            updateUIText(title: "Запись...", button: "Выключить", color: .label)
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
                        self.updateUIText(title: "Микрофон выключен", button: "Включить", color: .gray)
                    }
                    self.showAlert(title: self.createAlertMessage().0, message: self.createAlertMessage().1, actions: [settingsAction, cancel])
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
            resetUI()
            speechRecognitionManager.cancelSpeechRecognition()
        }
    }
    
    private func setUpConstraints() {
        
        closeButton.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
            maker.left.equalToSuperview().inset(20)
        }
        
        infoButton.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
            maker.width.equalTo(30)
            maker.height.equalTo(30)
            maker.right.equalToSuperview().inset(20)
        }
        
        commandIcon.snp.makeConstraints { maker in
            maker.top.equalTo(infoButton.snp.bottom).offset(50)
            maker.centerX.equalToSuperview()
            maker.width.equalTo(90)
            maker.height.equalTo(90)
        }
        
        commandTitle.snp.makeConstraints { maker in
            maker.top.equalTo(commandIcon.snp.bottom).offset(50)
            maker.centerX.equalToSuperview()
        }
        
        commandDescription.snp.makeConstraints { maker in
            maker.top.equalTo(commandTitle.snp.bottom).offset(50)
            maker.centerX.equalToSuperview()
        }
        
        turnMicrophoneButton.snp.makeConstraints { maker in
            maker.top.equalTo(commandDescription.snp.bottom).offset(50)
            maker.width.equalTo(120)
            maker.height.equalTo(30)
            maker.centerX.equalToSuperview()
        }
    }
    
    private func checkStartRecording() {
        if isAction {
            turnMicrophone()
        }
    }
    
    // MARK: - Voice Commands
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
            openWeeksList(text: text.lowercased())
        }
        turnOfMicrophone(text: text.lowercased())
        closeCurrentScreen(text: text.lowercased())
    }
    
    func createAlertMessage()-> (String, String) {
        let style = settingsManager.getSavedCommunicationStyle()
        let name = UserDefaults.standard.string(forKey: "name") ?? ""
        switch style {
        case .formal:
            return ("Микрофон выключен", "\(!name.isEmpty ? "\(name) хотите" : "Хотите") включить в настройках?")
        case .informal:
            return ("Микрофон выключен", "\(!name.isEmpty ? "\(name) хочешь" : "Хочешь") врубить в настройках?")
        }
    }
    
    func updateUIText(title: String, button: String, color: UIColor) {
        commandDescription.text = title
        commandDescription.textColor = color
        commandTitle.textColor = color
        turnMicrophoneButton.setTitle(button, for: .normal)
        commandIcon.tintColor = color
        updateMicButtonColor()
    }
    
    func updateMicButtonColor() {
        if isRecording {
            turnMicrophoneButton.backgroundColor = .systemRed
        } else {
            turnMicrophoneButton.backgroundColor = .systemGreen
        }
    }
    
    func updateCurrentCommand(name: String) {
        commandTitle.text = name
    }
}

extension VoiceCommandsViewController {
    
    // поиск раздела
    func searchSection(text: String) {
        
        for section in AGPUSections.sections {
            
            if text.lowercased().contains(section.voiceCommand) {
                
                self.updateIcon(icon: section.icon)
                
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                    self.goToWeb(url: section.url, image: section.icon, title: section.name, isSheet: false, isNotify: true)
                }
                updateCurrentCommand(name: "Раздел сайта")
                isOpened = true
                resetSpeechRecognition()
                break
            }
        }
    }
    
    // измение раздела сайта
    func changeSection(text: String) {
        
        for section in AGPUSections.sections {
            
            if text.lowercased().contains(section.voiceCommand) {
                resetSpeechRecognition()
                NotificationCenter.default.post(name: Notification.Name("section selected"), object: section)
            }
        }
    }
    
    // случайный раздел
    func generateRandomSection(text: String) {
        
        if text.lowercased().contains("случайный раздел") || text.lowercased().contains("случайно раздел") || text.lowercased().contains("рандомный раздел") || text.lowercased().contains("рандомно раздел") {
            
            let section = AGPUSections.sections[Int.random(in: 0..<AGPUSections.sections.count - 1)]
            
            updateIcon(icon: "dice")
            updateCurrentCommand(name: "Раздел сайта")
            
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                self.isOpened = true
                self.goToWeb(url: section.url, image: section.icon, title: section.name, isSheet: false, isNotify: true)
            }
            resetSpeechRecognition()
        }
    }
    
    func randomSectionOnScreen(text: String) {
        if text.lowercased().contains("случайный раздел") || text.lowercased().contains("случайно раздел") || text.lowercased().contains("рандомный раздел") || text.lowercased().contains("рандомно раздел") {
            let section = AGPUSections.sections[Int.random(in: 0..<AGPUSections.sections.count - 1)]
            resetSpeechRecognition()
            NotificationCenter.default.post(name: Notification.Name("section selected"), object: section)
        }
    }
    
    // поиск подраздела
    func searchSubSection(text: String) {
        
        for section in AGPUSections.sections {
            
            for subsection in section.subsections {
                
                if text.noWhitespacesWord().contains(subsection.voiceCommand) && subsection.url != "" {
                    resetSpeechRecognition()
                    self.updateIcon(icon: subsection.icon)
                    
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                        self.isOpened = true
                        self.goToWeb(url: subsection.url, image: subsection.icon, title: "АГПУ сайт", isSheet: false, isNotify: true)
                    }
                    updateCurrentCommand(name: "Раздел сайта")
                    break
                }
            }
        }
    }
    
    // измение подраздела сайта
    func changeSubSection(text: String) {
        
        for section in AGPUSections.sections {
            
            for subsection in section.subsections {
                
                if text.lowercased().contains(subsection.voiceCommand) {
                    resetSpeechRecognition()
                    NotificationCenter.default.post(name: Notification.Name("subsection selected"), object: subsection)
                }
            }
        }
    }
    
    // поиск корпуса
    func findBuilding(text: String) {
        for building in AGPUBuildings.buildings {
            if building.voiceCommands.contains(where: { text.lowercased().range(of: $0.lowercased()) != nil }) {
                resetSpeechRecognition()
                self.updateIcon(icon: "map icon")
                let vc = VoiceSearchAGPUBuildingMapViewController(building: building)
                let navVC = UINavigationController(rootViewController: vc)
                navVC.modalPresentationStyle = .fullScreen
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                    self.isOpened = true
                    self.present(navVC, animated: true)
                }
                updateCurrentCommand(name: "Найти корпус")
                break
            }
        }
    }
    
    // измение корпуса на карте
    func changeBuilding(text: String) {
        for building in AGPUBuildings.buildings {
            if building.voiceCommands.contains(where: { text.lowercased().range(of: $0.lowercased()) != nil }) {
                resetSpeechRecognition()
                NotificationCenter.default.post(name: Notification.Name("building selected"), object: building.pin)
            }
        }
    }
    
    func webActions(text: String) {
        
        if text.lowercased().lastWord().contains("назад") {
            NotificationCenter.default.post(name: Notification.Name("actions"), object: Actions.back)
        }
        
        if text.lowercased().lastWord().contains("вперед") || text.lowercased().lastWord().contains("вперёд")  {
            NotificationCenter.default.post(name: Notification.Name("actions"), object: Actions.forward)
        }
    }
    
    func resetSpeechRecognition() {
        speechRecognitionManager.cancelSpeechRecognition()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.speechRecognitionManager.startRecognize()
        }
    }
    
    // выключить микрофон
    func turnOfMicrophone(text: String) {
        if text.lowercased().contains("стоп") {
            if isOpened {
                self.dismiss(animated: true)
            }
            isOpened = false
            resetUI()
            turnMicrophoneButton.sendActions(for: .touchUpInside)
        }
    }
    
    // прокрутка веб страницы
    func scrollWebScreen(text: String) {
        for direction in VoiceDirections.directions {
            if direction.name.contains(text.lastWord()) {
                NotificationCenter.default.post(name: Notification.Name("scroll web page"), object: text.lastWord())
            }
        }
    }
    
    func closeCurrentScreen(text: String) {
        if text.lowercased().lastWord().contains("закр") {
            if isOpened {
                resetSpeechRecognition()
                isOpened = false
                updateIcon(icon: "mic")
                updateUIText(title: "Запись...", button: "Выключить", color: .label)
                updateCurrentCommand(name: "Команда")
                dismiss(animated: true)
            } else {
                resetSpeechRecognition()
            }
        }
    }
    
    func openWeeksList(text: String) {
        if text.lowercased().contains("недел") {
            isOpened = true
            resetSpeechRecognition()
            openWeeksTimetable()
            updateCurrentCommand(name: "Расписание")
        }
    }
    
    func updateIcon(icon: String) {
        let option = settingsManager.checkASPUButtonAnimationOption()
        DispatchQueue.main.async {
            self.commandIcon.image = UIImage(named: icon)
            switch option {
            case .spring:
                self.animation.springAnimation(view: self.commandIcon)
                HapticsManager.shared.hapticFeedback()
            case .flipFromTop:
                self.animation.flipAnimation(view: self.commandIcon, option: .transitionFlipFromTop) {
                    HapticsManager.shared.hapticFeedback()
                }
            case .flipFromRight:
                self.animation.flipAnimation(view: self.commandIcon, option: .transitionFlipFromRight) {
                    HapticsManager.shared.hapticFeedback()
                }
            case .flipFromLeft:
                self.animation.flipAnimation(view: self.commandIcon, option: .transitionFlipFromLeft) {
                    HapticsManager.shared.hapticFeedback()
                }
            case .flipFromBottom:
                self.animation.flipAnimation(view: self.commandIcon, option: .transitionFlipFromBottom) {
                    HapticsManager.shared.hapticFeedback()
                }
            case .none:
                HapticsManager.shared.hapticFeedback()
            }
        }
    }
    
    @objc func openWeeksTimetable() {
        let id = UserDefaults.standard.string(forKey: "group") ?? "ВМ-ИВТ-4-1"
        let subgroup = UserDefaults.standard.integer(forKey: "subgroup")
        let owner = UserDefaults.standard.string(forKey: "recentOwner") ?? "GROUP"
        let vc = AllWeeksListTableViewController(id: id, subgroup: subgroup, owner: owner)
        vc.isNotify = true
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        self.updateIcon(icon: "clock")
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            self.present(navVC, animated: true)
        }
    }
    
    func resetUI() {
        updateIcon(icon: "mic")
        updateUIText(title: "Микрофон выключен", button: "Включить", color: .gray)
        updateCurrentCommand(name: "Команда")
    }
    
    private func observeScreen() {
        NotificationCenter.default.addObserver(forName: Notification.Name("screen was closed"), object: nil, queue: .main) { _ in
            self.isOpened = false
            self.resetSpeechRecognition()
            self.updateIcon(icon: "mic")
            self.updateUIText(title: "Запись...", button: "Выключить", color: .label)
            self.updateCurrentCommand(name: "Команда")
        }
    }
}
