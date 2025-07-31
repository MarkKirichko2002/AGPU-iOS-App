//
//  AdditionalTabSplashScreenViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 23.07.2025.
//

import UIKit

final class AdditionalTabSplashScreenViewController: UIViewController {
    
    // MARK: - сервисы
    var animation: AnimationClassProtocol?
    var viewModel = AdditionalTabSplashScreenViewModel()
    
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
    private let tabIcon: SpringImageView = {
        let icon = SpringImageView()
        icon.isInteraction = false
        icon.tintColor = .label
        icon.contentMode = .scaleAspectFill
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    // название
    private let tabName: UILabel = {
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
        view.addSubviews(tabIcon, tabName)
        setUpLabel()
    }
    
    private func setUpLabel() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(springLabel))
        tabName.addGestureRecognizer(tap)
        springLabel()
    }
    
    @objc private func springLabel() {
        animation?.springAnimation(view: self.tabName)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            // иконка
            tabIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tabIcon.widthAnchor.constraint(equalToConstant: 100),
            tabIcon.heightAnchor.constraint(equalToConstant: 100),
            // название
            tabName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tabName.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            tabName.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            tabName.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            tabName.heightAnchor.constraint(equalToConstant: 100),
            tabName.topAnchor.constraint(equalTo: tabIcon.bottomAnchor, constant: 50)
        ])
    }
    
    private func showSplashScreen() {
        
        viewModel.registerAdditionalTabHandler { icon, name in
            
            DispatchQueue.main.async {
                
                self.tabIcon.image = UIImage(named: icon)
                self.animation?.springAnimation(view: self.tabIcon)
                
                Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
                    self.tabName.text = name
                    self.animation?.springAnimation(view: self.tabName)
                }
                
                Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { _ in
                    let controller = AGPUTabBarController()
                    controller.modalPresentationStyle = .fullScreen
                    controller.modalTransitionStyle = .crossDissolve
                    self.present(controller, animated: true, completion: nil)
                }
            }
        }
        
        viewModel.getAdditionalTab()
    }
}
