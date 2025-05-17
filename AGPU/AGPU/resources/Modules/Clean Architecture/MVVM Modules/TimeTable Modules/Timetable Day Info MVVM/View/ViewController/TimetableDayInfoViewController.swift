//
//  TimetableDayInfoViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 17.05.2025.
//

import UIKit

final class TimetableDayInfoViewController: UIViewController {
    
    // MARK: - UI
    private var closeButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(named: "cross"), for: .normal)
        return button
    }()
    
    private let warningIcon: SpringImageView = {
        let image = SpringImageView()
        image.image = UIImage(named: "clock")
        image.tintColor = .label
        image.isUserInteractionEnabled = true
        return image
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Загрузка..."
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
        button.setTitle("Понятно", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .black)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    // MARK: - сервисы
    private let viewModel = TimetableDayInfoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpConstraints()
        bindViewModel()
    }
        
    private func setUpView() {
        view.backgroundColor = .systemBackground
        view.addSubviews(closeButton, warningIcon, titleLabel, updateButton)
        updateButton.addTarget(self, action: #selector(closeScreen), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeScreen), for: .touchUpInside)
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        dismiss(animated: true)
    }
            
    private func setUpConstraints() {
        
        closeButton.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
            maker.right.equalToSuperview().inset(20)
        }
        
        warningIcon.snp.makeConstraints { maker in
            maker.top.equalTo(closeButton.snp.bottom).offset(20)
            maker.centerX.equalToSuperview()
            maker.width.equalTo(75)
            maker.height.equalTo(75)
        }
        
        titleLabel.snp.makeConstraints { maker in
            maker.top.equalTo(warningIcon.snp.bottom).offset(60)
            maker.left.equalToSuperview().inset(30)
            maker.right.equalToSuperview().inset(30)
            maker.centerX.equalToSuperview()
        }
        
        updateButton.snp.makeConstraints { maker in
            maker.width.equalTo(100)
            maker.height.equalTo(30)
            maker.top.equalTo(titleLabel.snp.bottom).offset(60)
            maker.centerX.equalToSuperview()
        }
    }
    
    func bindViewModel() {
        viewModel.registerInfoHandler { date, count in
            DispatchQueue.main.async {
                self.titleLabel.text = "\(date)\n\nвсего пар: \(count)"
            }
        }
        viewModel.getTimetableDayInfo()
    }
}
