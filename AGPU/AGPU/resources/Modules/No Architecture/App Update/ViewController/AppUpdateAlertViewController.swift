//
//  AppUpdateAlertViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 26.05.2024.
//

import UIKit

class AppUpdateAlertViewController: UIViewController {
    
    // MARK: - UI
    private var closeButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(named: "cross"), for: .normal)
        return button
    }()
    
    private let warningIcon: SpringImageView = {
        let image = SpringImageView()
        image.image = UIImage(named: "exclamation")
        image.tintColor = .label
        image.isUserInteractionEnabled = true
        return image
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Обнаружено новое обновление! Хотите обновить приложение сейчас?"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let updateButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.setTitle("Обновить", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .black)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.setTitle("Отмена", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .black)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpConstraints()
    }
        
    private func setUpView() {
        view.backgroundColor = .systemBackground
        view.addSubviews(closeButton, warningIcon, titleLabel, updateButton, cancelButton)
        updateButton.addTarget(self, action: #selector(goToAppStore), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(closeScreen), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeScreen), for: .touchUpInside)
    }
    
    @objc private func goToAppStore() {
        if let appStoreURL = URL(string: "https://apps.apple.com/app/фгбоу-во-агпу/id6458836690") {
            HapticsManager.shared.hapticFeedback()
            UIApplication.shared.open(appStoreURL)
        }
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        dismiss(animated: true)
    }
            
    private func setUpConstraints() {
        
        closeButton.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(60)
            maker.right.equalToSuperview().inset(20)
        }
        
        warningIcon.snp.makeConstraints { maker in
            maker.top.equalTo(closeButton.snp.bottom).offset(20)
            maker.centerX.equalToSuperview()
            maker.width.equalTo(90)
            maker.height.equalTo(90)
        }
        
        titleLabel.snp.makeConstraints { maker in
            maker.top.equalTo(warningIcon.snp.bottom).offset(60)
            maker.left.equalToSuperview().inset(30)
            maker.right.equalToSuperview().inset(30)
            maker.centerX.equalToSuperview()
        }
        
        updateButton.snp.makeConstraints { maker in
            maker.top.equalTo(titleLabel.snp.bottom).offset(50)
            maker.centerX.equalToSuperview()
        }
        
        cancelButton.snp.makeConstraints { maker in
            maker.top.equalTo(updateButton.snp.bottom).offset(50)
            maker.leading.equalTo(updateButton.snp.leading)
            maker.trailing.equalTo(updateButton.snp.trailing)
            maker.centerX.equalToSuperview()
        }
    }
}
