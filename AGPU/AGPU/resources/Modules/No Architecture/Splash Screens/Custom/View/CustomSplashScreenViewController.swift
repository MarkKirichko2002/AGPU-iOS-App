//
//  CustomSplashScreenViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 28.02.2024.
//

import UIKit

final class CustomSplashScreenViewController: UIViewController {
    
    // MARK: - UI
    // иконка
    private let CustomIcon: SpringImageView = {
        let icon = SpringImageView()
        icon.clipsToBounds = true
        icon.isInteraction = false
        icon.contentMode = .scaleAspectFill
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    // название
    let CustomTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - сервисы
    var animation: AnimationClassProtocol?
    let realmManager = RealmManager()
    
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
        view.addSubviews(CustomIcon, CustomTitleLabel)
        setUpLabel()
    }
    
    private func setUpLabel() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(springLabel))
        CustomTitleLabel.addGestureRecognizer(tap)
        springLabel()
    }
    
    @objc private func springLabel() {
        animation?.springAnimation(view: self.CustomTitleLabel)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            // иконка
            CustomIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            CustomIcon.widthAnchor.constraint(equalToConstant: 180),
            CustomIcon.heightAnchor.constraint(equalToConstant: 180),
            // название
            CustomTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            CustomTitleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            CustomTitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            CustomTitleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            CustomTitleLabel.heightAnchor.constraint(equalToConstant: 100),
            CustomTitleLabel.topAnchor.constraint(equalTo: CustomIcon.bottomAnchor, constant: 50)
        ])
    }
    
    private func showSplashScreen() {
        
        let screen = realmManager.getSplashScreen()
        
        let color = Colors.allCases.first { $0.title == screen.color }
        view.backgroundColor = color?.color ?? .systemBackground
        
        CustomIcon.image = UIImage(data: screen.image ?? Data())
        animation?.springAnimation(view: CustomIcon)
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
            self.CustomTitleLabel.text = screen.title
            self.CustomTitleLabel.textColor = color == nil ? .label : .white
            self.animation?.springAnimation(view: self.CustomTitleLabel)
        }
        
        Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { _ in
            let controller = AGPUTabBarController()
            controller.modalPresentationStyle = .fullScreen
            controller.modalTransitionStyle = .crossDissolve
            self.present(controller, animated: true, completion: nil)
        }
    }
}
