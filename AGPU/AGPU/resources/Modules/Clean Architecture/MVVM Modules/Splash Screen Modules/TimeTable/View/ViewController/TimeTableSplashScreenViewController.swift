//
//  TimeTableSplashScreenViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 13.03.2024.
//

import UIKit

final class TimeTableSplashScreenViewController: UIViewController {
    
    // MARK: - сервисы
    var animation: AnimationClassProtocol?
    var viewModel = TimeTableSplashScreenViewModel()
    
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
    private let TimeTableImage: SpringImageView = {
        let icon = SpringImageView()
        icon.isInteraction = false
        icon.tintColor = .label
        icon.contentMode = .scaleAspectFill
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    // название
    private let TimeTableDescription: UILabel = {
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
        view.addSubviews(TimeTableImage, TimeTableDescription)
        setUpLabel()
    }
    
    private func setUpLabel() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(springLabel))
        TimeTableDescription.addGestureRecognizer(tap)
        springLabel()
    }
    
    @objc private func springLabel() {
        animation?.springAnimation(view: self.TimeTableDescription)
        HapticsManager.shared.hapticFeedback()
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            // иконка
            TimeTableImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            TimeTableImage.widthAnchor.constraint(equalToConstant: 250),
            TimeTableImage.heightAnchor.constraint(equalToConstant: 250),
            // название
            TimeTableDescription.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            TimeTableDescription.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            TimeTableDescription.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            TimeTableDescription.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            TimeTableDescription.heightAnchor.constraint(equalToConstant: 100),
            TimeTableDescription.topAnchor.constraint(equalTo: TimeTableImage.bottomAnchor, constant: 50)
        ])
    }
    
    private func showSplashScreen() {
        
        viewModel.registerTimeTableHandler { timetable in
            
            DispatchQueue.main.async {
                
                self.TimeTableImage.image = timetable.image
                self.animation?.springAnimation(view: self.TimeTableImage)
                
                Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
                    self.TimeTableDescription.text = timetable.description
                    self.TimeTableDescription.textColor = self.viewModel.textColor()
                    self.animation?.springAnimation(view: self.TimeTableDescription)
                }
                
                Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { _ in
                    let controller = AGPUTabBarController()
                    controller.modalPresentationStyle = .fullScreen
                    controller.modalTransitionStyle = .crossDissolve
                    self.present(controller, animated: true, completion: nil)
                }
            }
        }
        
        viewModel.getTimeTable()
    }
}
