//
//  NewsSplashScreenViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 14.03.2024.
//

import UIKit

final class NewsSplashScreenViewController: UIViewController {
    
    // MARK: - сервисы
    var animation: AnimationClassProtocol?
    var viewModel = NewsSplashScreenViewModel()
    
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
    private let NewsCategoryIcon: SpringImageView = {
        let icon = SpringImageView()
        icon.isInteraction = false
        icon.tintColor = .label
        icon.contentMode = .scaleAspectFill
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    // название
    private let NewsCategoryDescription: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .bold)
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
        view.addSubviews(NewsCategoryIcon, NewsCategoryDescription)
        setUpLabel()
    }
    
    private func setUpLabel() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(springLabel))
        NewsCategoryDescription.addGestureRecognizer(tap)
        springLabel()
    }
    
    @objc private func springLabel() {
        animation?.springAnimation(view: self.NewsCategoryDescription)
        HapticsManager.shared.hapticFeedback()
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            // иконка
            NewsCategoryIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            NewsCategoryIcon.widthAnchor.constraint(equalToConstant: 180),
            NewsCategoryIcon.heightAnchor.constraint(equalToConstant: 180),
            // название
            NewsCategoryDescription.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            NewsCategoryDescription.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            NewsCategoryDescription.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            NewsCategoryDescription.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            NewsCategoryDescription.heightAnchor.constraint(equalToConstant: 100),
            NewsCategoryDescription.topAnchor.constraint(equalTo: NewsCategoryIcon.bottomAnchor, constant: 50)
        ])
    }
    
    private func showSplashScreen() {
        
        viewModel.registerNewsHandler { description in
            
            DispatchQueue.main.async {
                
                self.NewsCategoryIcon.image = UIImage(named: description.categoryIcon)
                self.animation?.springAnimation(view: self.NewsCategoryIcon)
                
                Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
                    self.NewsCategoryDescription.text = "\(description.categoryName) новостей сегодня: \(description.newsCount)"
                    self.animation?.springAnimation(view: self.NewsCategoryDescription)
                }
                
                Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { _ in
                    let controller = AGPUTabBarController()
                    controller.modalPresentationStyle = .fullScreen
                    controller.modalTransitionStyle = .crossDissolve
                    self.present(controller, animated: true, completion: nil)
                }
            }
        }
        
        viewModel.getNews()
    }
}
