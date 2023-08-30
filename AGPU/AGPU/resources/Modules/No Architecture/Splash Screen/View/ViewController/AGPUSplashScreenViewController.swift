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
        label.font = .systemFont(ofSize: 21, weight: .black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 1 год
    private let AnniversaryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubviews(AGPUIcon, AGPUTitleLabel, AnniversaryLabel)
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
            AGPUTitleLabel.topAnchor.constraint(equalTo: AGPUIcon.bottomAnchor, constant: 40),
            // 1 год
            AnniversaryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            AnniversaryLabel.heightAnchor.constraint(equalToConstant: 30),
            AnniversaryLabel.topAnchor.constraint(equalTo: AGPUTitleLabel.bottomAnchor, constant: 60),
        ])
    }
    
    private func showSplashScreen() {
        
        animation?.SpringAnimation(view: AGPUIcon)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.AGPUTitleLabel.text = "ФГБОУ ВО «АГПУ»"
            self.animation?.SpringAnimation(view: self.AGPUTitleLabel)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.AnniversaryLabel.text = "100 лет 🎉!!!"
            self.animation?.SpringAnimation(view: self.AnniversaryLabel)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            let controller = AGPUTabBarController()
            controller.modalTransitionStyle = .crossDissolve
            controller.modalPresentationStyle = .currentContext
            self.present(controller, animated: false, completion: nil)
        }
    }
}
