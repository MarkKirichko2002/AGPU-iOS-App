//
//  PairsCountViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 08.02.2025.
//

import UIKit

final class PairsCountViewController: UIViewController {
    
    // MARK: - UI
    private var closeButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(named: "cross"), for: .normal)
        return button
    }()
    
    private let hintIcon: SpringImageView = {
        let image = SpringImageView()
        image.image = UIImage(named: "clock")
        image.tintColor = .label
        image.isUserInteractionEnabled = true
        return image
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let pairsCountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    private let okButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.setTitle("Хорошо", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .black)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
        
    var date: String
    var pairsCount: Int
    
    // MARK: - сервисы
    private let speechRecognitionManager = SpeechRecognitionManager()
    private let settingsManager = SettingsManager()
    
    // MARK: - Init
    init(date: String, pairsCount: Int) {
        self.date = date
        self.pairsCount = pairsCount
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startRecognition()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        cancelRecognition()
    }
        
    private func setUpView() {
        view.backgroundColor = .systemBackground
        view.addSubviews(closeButton, hintIcon, dateLabel, pairsCountLabel, okButton)
        dateLabel.text = date
        pairsCountLabel.text = "Всего пар: \(pairsCount)"
        okButton.addTarget(self, action: #selector(closeScreen), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeScreen), for: .touchUpInside)
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        dismiss(animated: true)
    }
            
    private func setUpConstraints() {
        
        closeButton.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
            maker.right.equalToSuperview().inset(20)
        }
        
        hintIcon.snp.makeConstraints { maker in
            maker.top.equalTo(closeButton.snp.bottom).offset(20)
            maker.centerX.equalToSuperview()
            maker.width.equalTo(75)
            maker.height.equalTo(75)
        }
        
        dateLabel.snp.makeConstraints { maker in
            maker.top.equalTo(hintIcon.snp.bottom).offset(60)
            maker.left.equalToSuperview().inset(30)
            maker.right.equalToSuperview().inset(30)
            maker.centerX.equalToSuperview()
        }
        
        pairsCountLabel.snp.makeConstraints { maker in
            maker.top.equalTo(dateLabel.snp.bottom).offset(50)
            maker.left.equalToSuperview().inset(30)
            maker.right.equalToSuperview().inset(30)
            maker.centerX.equalToSuperview()
        }
        
        okButton.snp.makeConstraints { maker in
            maker.width.equalTo(80)
            maker.height.equalTo(30)
            maker.top.equalTo(pairsCountLabel.snp.bottom).offset(50)
            maker.centerX.equalToSuperview()
        }
    }
    
    func startRecognition() {
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
            self.startRecognize()
        }
    }
    
    func startRecognize() {
        speechRecognitionManager.requestSpeechAndMicrophonePermission()
        speechRecognitionManager.registerSpeechAuthorizationHandler { auth in
            switch auth {
            case .notDetermined:
                print("Разрешение на распознавание речи еще не было получено.")
            case .denied:
                let settingsAction = UIAlertAction(title: "Перейти в настройки", style: .default) { _ in
                    self.openSettings()
                }
                let cancel = UIAlertAction(title: "Отмена", style: .destructive) { _ in}
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
            self.voiceCommands(text: text)
        }
    }
    
    func cancelRecognition() {
        let screens = settingsManager.loadScreens(way: differentWays.voiceCommands)
        if screens.contains(appScreens.timetableDay) {
            speechRecognitionManager.cancelSpeechRecognition()
        }
    }
    
    func voiceCommands(text: String) {
        if text.lowercased().contains("закр") {
            cancelRecognition()
            dismiss(animated: true)
        }
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
}
