//
//  RandomSplashScreenViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 19.04.2024.
//

import UIKit

class RandomSplashScreenViewController: UIViewController {
    
    // MARK: - сервисы
    private let viewModel = RandomSplashScreenViewModel()
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
    private let DiceIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "dice")
        icon.isUserInteractionEnabled = true
        icon.tintColor = .label
        icon.contentMode = .scaleAspectFill
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    // название
    private let RandomDescription: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Нажмите на дайс или встряхните ваш \(UIDevice.name) для случайного выбора экрана заставки."
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setUpConstraints()
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            showRandomScreen()
        }
    }
        
    private func setUpView() {
        view.backgroundColor = .systemBackground
        view.addSubviews(DiceIcon, RandomDescription)
        setUpIcon()
    }
    
    private func setUpIcon() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(showRandomScreen))
        DiceIcon.addGestureRecognizer(tap)
    }
    
    @objc private func showRandomScreen() {
        animation.flipAnimation(view: self.DiceIcon, option: .transitionFlipFromRight) {
            let randomVC = self.viewModel.generateRandomScreen()
            randomVC.modalPresentationStyle = .fullScreen
            randomVC.modalTransitionStyle = .crossDissolve
            HapticsManager.shared.hapticFeedback()
            self.present(randomVC, animated: true, completion: nil)
        }
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            // иконка
            DiceIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            DiceIcon.widthAnchor.constraint(equalToConstant: 100),
            DiceIcon.heightAnchor.constraint(equalToConstant: 100),
            // название
            RandomDescription.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            RandomDescription.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            RandomDescription.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            RandomDescription.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            RandomDescription.heightAnchor.constraint(equalToConstant: 100),
            RandomDescription.topAnchor.constraint(equalTo: DiceIcon.bottomAnchor, constant: 50)
        ])
    }
}
