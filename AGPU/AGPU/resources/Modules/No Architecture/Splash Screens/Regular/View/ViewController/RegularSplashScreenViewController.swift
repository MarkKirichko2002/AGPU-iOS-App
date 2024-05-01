//
//  RegularSplashScreenViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 09.06.2023.
//

import UIKit

final class RegularSplashScreenViewController: UIViewController {
    
    // MARK: - сервисы
    var animation: AnimationClassProtocol?
    
    var icon: String = ""
    var text: String = ""
    var width: CGFloat = 0.0
    var height: CGFloat = 0.0
    
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
    private let AGPUIcon: SpringImageView = {
        let icon = SpringImageView()
        icon.isInteraction = false
        icon.contentMode = .scaleAspectFill
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    // название
    private let AGPUTitleLabel: UILabel = {
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
    init(animation: AnimationClassProtocol?, icon: String, text: String, width: CGFloat, height: CGFloat) {
        self.animation = animation
        self.icon = icon
        self.text = text
        self.width = width
        self.height = height
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUpView() {
        view.backgroundColor = .systemBackground
        view.addSubviews(AGPUIcon, AGPUTitleLabel)
        AGPUIcon.image = UIImage(named: icon)
        setUpLabel()
    }
    
    private func setUpLabel() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(springLabel))
        AGPUTitleLabel.addGestureRecognizer(tap)
        springLabel()
    }
    
    @objc private func springLabel() {
        animation?.springAnimation(view: self.AGPUTitleLabel)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            // иконка
            AGPUIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            AGPUIcon.widthAnchor.constraint(equalToConstant: width),
            AGPUIcon.heightAnchor.constraint(equalToConstant: height),
            // название
            AGPUTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            AGPUTitleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            AGPUTitleLabel.heightAnchor.constraint(equalToConstant: 30),
            AGPUTitleLabel.topAnchor.constraint(equalTo: AGPUIcon.bottomAnchor, constant: 50)
        ])
    }
    
    private func showSplashScreen() {
        
        animation?.springAnimation(view: AGPUIcon)
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
            self.AGPUTitleLabel.text = self.text
            self.animation?.springAnimation(view: self.AGPUTitleLabel)
        }
            
        Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { _ in
            let controller = AGPUTabBarController()
            controller.modalPresentationStyle = .fullScreen
            controller.modalTransitionStyle = .crossDissolve
            self.present(controller, animated: true, completion: nil)
        }
    }
}
