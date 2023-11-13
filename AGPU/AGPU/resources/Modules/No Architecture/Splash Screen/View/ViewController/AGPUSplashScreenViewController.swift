//
//  AGPUSplashScreenViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 09.06.2023.
//

import UIKit

final class AGPUSplashScreenViewController: UIViewController {
    
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
        }
    }
    
    // MARK: - UI
    // иконка
    private let AGPUIcon: SpringImageView = {
        let icon = SpringImageView()
        icon.image = UIImage(named: "АГПУ")
        icon.isInteraction = false
        icon.contentMode = .scaleAspectFill
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    // название
    private let AGPUTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 21, weight: .black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubviews(AGPUIcon, AGPUTitleLabel)
        setUpConstraints()
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
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            // иконка
            AGPUIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            AGPUIcon.widthAnchor.constraint(equalToConstant: 200),
            AGPUIcon.heightAnchor.constraint(equalToConstant: 200),
            // название
            AGPUTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            AGPUTitleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            AGPUTitleLabel.heightAnchor.constraint(equalToConstant: 30),
            AGPUTitleLabel.topAnchor.constraint(equalTo: AGPUIcon.bottomAnchor, constant: 50)
        ])
    }
    
    private func showSplashScreen() {
        
        animation?.springAnimation(view: AGPUIcon)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.AGPUTitleLabel.text = "ФГБОУ ВО «АГПУ»"
            self.animation?.springAnimation(view: self.AGPUTitleLabel)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            let controller = AGPUTabBarController()
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: false, completion: nil)
        }
    }
}
