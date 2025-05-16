//
//  BuildingSplashScreenViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 29.08.2024.
//

import UIKit

final class BuildingSplashScreenViewController: UIViewController {
    
    // MARK: - UI
    // иконка
    private let BuildingIcon: SpringImageView = {
        let icon = SpringImageView()
        icon.clipsToBounds = true
        icon.isInteraction = false
        icon.contentMode = .scaleAspectFill
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    // название
    let BuildingName: UILabel = {
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
        view.addSubviews(BuildingIcon, BuildingName)
        setUpLabel()
    }
    
    private func setUpLabel() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(springLabel))
        BuildingName.addGestureRecognizer(tap)
        springLabel()
    }
    
    @objc private func springLabel() {
        animation?.springAnimation(view: self.BuildingName)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            // иконка
            BuildingIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            BuildingIcon.widthAnchor.constraint(equalToConstant: 200),
            BuildingIcon.heightAnchor.constraint(equalToConstant: 200),
            // название
            BuildingName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            BuildingName.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            BuildingName.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            BuildingName.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            BuildingName.heightAnchor.constraint(equalToConstant: 100),
            BuildingName.topAnchor.constraint(equalTo: BuildingIcon.bottomAnchor, constant: 50)
        ])
    }
    
    private func showSplashScreen() {
        
        let building = randomBuilding()
        
        BuildingIcon.image = UIImage(named: building.image)
        animation?.springAnimation(view: BuildingIcon)
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
            self.BuildingName.text = building.name
            self.animation?.springAnimation(view: self.BuildingName)
        }
        
        Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { _ in
            let controller = AGPUTabBarController()
            controller.modalPresentationStyle = .fullScreen
            controller.modalTransitionStyle = .crossDissolve
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func randomBuilding()-> AGPUBuildingModel {
        return AGPUBuildings.buildings.randomElement()!
    }
}
