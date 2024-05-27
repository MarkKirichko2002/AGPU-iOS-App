//
//  HintViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 27.05.2024.
//

import UIKit

class HintViewController: UIViewController {
    
    // MARK: - UI
    private var closeButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(named: "cross"), for: .normal)
        return button
    }()
    
    private let hintIcon: SpringImageView = {
        let image = SpringImageView()
        image.image = UIImage(named: "bulb")
        image.tintColor = .label
        image.isUserInteractionEnabled = true
        return image
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let okButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.setTitle("Хорошо", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .black)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
        
    var info: String
    var isNotify = false
    
    // MARK: - Init
    init(info: String) {
        self.info = info
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpConstraints()
    }
        
    private func setUpView() {
        view.backgroundColor = .systemBackground
        view.addSubviews(closeButton, hintIcon, titleLabel, okButton)
        titleLabel.text = info
        okButton.addTarget(self, action: #selector(closeScreen), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeScreen), for: .touchUpInside)
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        if isNotify {
            sendScreenWasClosedNotification()
        }
        dismiss(animated: true)
    }
            
    private func setUpConstraints() {
        
        closeButton.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(60)
            maker.right.equalToSuperview().inset(20)
        }
        
        hintIcon.snp.makeConstraints { maker in
            maker.top.equalTo(closeButton.snp.bottom).offset(20)
            maker.centerX.equalToSuperview()
            maker.width.equalTo(90)
            maker.height.equalTo(90)
        }
        
        titleLabel.snp.makeConstraints { maker in
            maker.top.equalTo(hintIcon.snp.bottom).offset(60)
            maker.left.equalToSuperview().inset(30)
            maker.right.equalToSuperview().inset(30)
            maker.centerX.equalToSuperview()
        }
        
        okButton.snp.makeConstraints { maker in
            maker.top.equalTo(titleLabel.snp.bottom).offset(50)
            maker.centerX.equalToSuperview()
        }
    }
}
