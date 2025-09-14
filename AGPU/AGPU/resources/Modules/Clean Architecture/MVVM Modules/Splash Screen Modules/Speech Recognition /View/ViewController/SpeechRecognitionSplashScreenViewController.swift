//
//  SpeechRecognitionSplashScreenViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 14.09.2025.
//

import UIKit

final class SpeechRecognitionSplashScreenViewController: UIViewController {

    // MARK: - сервисы
    private let viewModel = SpeechRecognitionSplashScreenViewModel()
    private let animation = AnimationClass()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        let theme = UserDefaults.loadData(type: AppThemeModel.self, key: "theme")?.theme ?? .light
        switch theme {
        case .unspecified:
            return .default
        case .light:
            return .darkContent
        case .dark:
            return .lightContent
        @unknown default:
            return .default
        }
    }
    
    // MARK: - UI
    // иконка
    private let micIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "mic")
        icon.isUserInteractionEnabled = true
        icon.tintColor = .label
        icon.contentMode = .scaleAspectFill
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    // название
    private let speechDescription: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Нужно назвать имя экрана заставки для его выбора"
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.startRecognize()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.cancelRecognition()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setUpConstraints()
    }
    
    private func setUpView() {
        view.backgroundColor = .systemBackground
        view.addSubviews(micIcon, speechDescription)
        setUpInfoButton()
    }
    
    private func setUpInfoButton() {
        let infoButton = UIButton()
        infoButton.tintColor = .label
        infoButton.setImage(UIImage(named: "info icon"), for: .normal)
        infoButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(infoButton)
        NSLayoutConstraint.activate([
            infoButton.safeAreaLayoutGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5.0),
            infoButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30.0),
            infoButton.widthAnchor.constraint(equalToConstant: 40.0),
            infoButton.heightAnchor.constraint(equalToConstant: 40.0)
        ])
        infoButton.addTarget(self, action: #selector(showInfo), for: .touchUpInside)
    }
    
    @objc private func showInfo() {
        let vc = VoiceCommandsListTableViewController(type: .splashScreen)
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        navVC.modalTransitionStyle = .crossDissolve
        self.present(navVC, animated: true, completion: nil)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            // иконка
            micIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            micIcon.widthAnchor.constraint(equalToConstant: 100),
            micIcon.heightAnchor.constraint(equalToConstant: 100),
            // название
            speechDescription.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            speechDescription.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            speechDescription.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            speechDescription.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            speechDescription.heightAnchor.constraint(equalToConstant: 100),
            speechDescription.topAnchor.constraint(equalTo: micIcon.bottomAnchor, constant: 50)
        ])
    }
    
    private func bindViewModel() {
        viewModel.alertHandler = { isPresent, title, message in
            if isPresent {
                let goToSettings = UIAlertAction(title: "Перейти в настройки", style: .default) { _ in
                    self.openSettings()
                }
                let cancel = UIAlertAction(title: "Отмена", style: .cancel) { _ in}
                self.showAlert(title: title, message: message, actions: [goToSettings, cancel])
            }
        }
        viewModel.registerSplashScreenViewControllerHandler { vc in
            self.updateUI()
            self.showSplashScreen(vc: vc, seconds: 2)
        }
        viewModel.registerSkipHandler { vc in
            self.showSplashScreen(vc: vc, seconds: 0)
        }
    }
    
    func updateUI() {
        DispatchQueue.main.async {
            self.speechDescription.text = "Экран заставки \"\(self.viewModel.currentScreen.rawValue)\" был выбран!"
        }
    }
    
    func showSplashScreen(vc: UIViewController, seconds: Double) {
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        Timer.scheduledTimer(withTimeInterval: seconds, repeats: false) { _ in
            self.present(vc, animated: true, completion: nil)
        }
    }
}
