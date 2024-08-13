//
//  SeasonSplashScreenViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 13.08.2024.
//

import UIKit

final class SeasonSplashScreenViewController: UIViewController {
    
    // MARK: - сервисы
    var animation: AnimationClassProtocol?
    var viewModel = SeasonSplashScreenViewModel()
    
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
    private let SeasonIcon: SpringImageView = {
        let icon = SpringImageView()
        icon.isInteraction = false
        icon.tintColor = .label
        icon.contentMode = .scaleAspectFill
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    // название
    private let SeasonName: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        label.textColor = .label
        label.textAlignment = .center
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
        view.addSubviews(SeasonIcon, SeasonName)
        setUpLabel()
    }
    
    private func setUpLabel() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(springLabel))
        SeasonName.addGestureRecognizer(tap)
        springLabel()
    }
    
    @objc private func springLabel() {
        animation?.springAnimation(view: self.SeasonName)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            // иконка
            SeasonIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            SeasonIcon.widthAnchor.constraint(equalToConstant: 100),
            SeasonIcon.heightAnchor.constraint(equalToConstant: 100),
            // название
            SeasonName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            SeasonName.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            SeasonName.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            SeasonName.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            SeasonName.heightAnchor.constraint(equalToConstant: 100),
            SeasonName.topAnchor.constraint(equalTo: SeasonIcon.bottomAnchor, constant: 50)
        ])
    }
    
    private func showSplashScreen() {
        
        viewModel.registerSeasonHandler { icon, name in
            
            DispatchQueue.main.async {
                
                self.SeasonIcon.image = UIImage(named: icon)
                self.animation?.springAnimation(view: self.SeasonIcon)
                
                Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
                    self.SeasonName.text = name
                    self.animation?.springAnimation(view: self.SeasonName)
                }
                
                Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { _ in
                    let controller = AGPUTabBarController()
                    controller.modalPresentationStyle = .fullScreen
                    controller.modalTransitionStyle = .crossDissolve
                    self.present(controller, animated: true, completion: nil)
                }
            }
        }
        
        viewModel.getSeason()
    }
}
