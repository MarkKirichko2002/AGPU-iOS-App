//
//  YourStatusSplashScreenViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 09.02.2024.
//

import UIKit

final class YourStatusSplashScreenViewController: UIViewController {
    
    // MARK: - сервисы
    var animation: AnimationClassProtocol?
    
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
    private let StatusIcon: SpringImageView = {
        let icon = SpringImageView()
        icon.tintColor = .label
        icon.isInteraction = false
        icon.contentMode = .scaleAspectFill
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    // название
    private let StatusName: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.textColor = .label
        label.font = .systemFont(ofSize: 20, weight: .black)
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showSplashScreen()
    }
    
    // MARK: - Init
    init(animation: AnimationClassProtocol?) {
        self.animation = animation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUpView() {
        view.backgroundColor = .systemBackground
        view.addSubviews(StatusIcon, StatusName)
        setUpLabel()
    }
    
    private func setUpLabel() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(springLabel))
        StatusName.addGestureRecognizer(tap)
        springLabel()
    }
    
    @objc private func springLabel() {
        animation?.springAnimation(view: self.StatusName)
        HapticsManager.shared.hapticFeedback()
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            // иконка
            StatusIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            StatusIcon.widthAnchor.constraint(equalToConstant: 100),
            StatusIcon.heightAnchor.constraint(equalToConstant: 100),
            // название
            StatusName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            StatusName.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            StatusName.heightAnchor.constraint(equalToConstant: 30),
            StatusName.topAnchor.constraint(equalTo: StatusIcon.bottomAnchor, constant: 50)
        ])
    }
    
    private func showSplashScreen() {
        
        guard let status = UserDefaults.loadData(type: UserStatusModel.self, key: "user status") else {return}
        
        StatusIcon.image = UIImage(named: status.icon)
        animation?.springAnimation(view: StatusIcon)
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
            self.StatusName.text = status.name
            self.animation?.springAnimation(view: self.StatusName)
        }
        
        Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { _ in
            let controller = AGPUTabBarController()
            controller.modalPresentationStyle = .fullScreen
            controller.modalTransitionStyle = .crossDissolve
            self.present(controller, animated: true, completion: nil)
        }
    }
}

