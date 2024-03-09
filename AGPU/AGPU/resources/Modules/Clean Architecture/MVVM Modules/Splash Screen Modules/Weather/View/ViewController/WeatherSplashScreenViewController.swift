//
//  WeatherSplashScreenViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 10.03.2024.
//

import UIKit

final class WeatherSplashScreenViewController: UIViewController {
    
    // MARK: - сервисы
    var animation: AnimationClassProtocol?
    var viewModel = WeatherSplashScreenViewModel()
    
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
    private let WeatherIcon: SpringImageView = {
        let icon = SpringImageView()
        icon.isInteraction = false
        icon.tintColor = .label
        icon.contentMode = .scaleAspectFill
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    // название
    private let WeatherDescription: UILabel = {
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
        view.addSubviews(WeatherIcon, WeatherDescription)
        setUpLabel()
    }
    
    private func setUpLabel() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(springLabel))
        WeatherDescription.addGestureRecognizer(tap)
        springLabel()
    }
    
    @objc private func springLabel() {
        animation?.springAnimation(view: self.WeatherDescription)
        HapticsManager.shared.hapticFeedback()
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            // иконка
            WeatherIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            WeatherIcon.widthAnchor.constraint(equalToConstant: 100),
            WeatherIcon.heightAnchor.constraint(equalToConstant: 100),
            // название
            WeatherDescription.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            WeatherDescription.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            WeatherDescription.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            WeatherDescription.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            WeatherDescription.heightAnchor.constraint(equalToConstant: 100),
            WeatherDescription.topAnchor.constraint(equalTo: WeatherIcon.bottomAnchor, constant: 50)
        ])
    }
    
    private func showSplashScreen() {
        
        viewModel.registerWeatherHandler { weather in
            
            DispatchQueue.main.async {
                
                self.WeatherIcon.image = UIImage(systemName: weather.currentWeather.symbolName)
                self.animation?.springAnimation(view: self.WeatherIcon)
                
                Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
                    self.WeatherDescription.text = self.viewModel.formatWeather(weather: weather)
                    self.animation?.springAnimation(view: self.WeatherDescription)
                }
                
                Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { _ in
                    let controller = AGPUTabBarController()
                    controller.modalPresentationStyle = .fullScreen
                    controller.modalTransitionStyle = .crossDissolve
                    self.present(controller, animated: true, completion: nil)
                }
            }
        }
        
        viewModel.getWeather()
    }
}
