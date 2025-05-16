//
//  SimpleModeViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 15.09.2024.
//

import UIKit

final class SimpleModeViewController: UIViewController {

    private let hintIcon: SpringImageView = {
        let image = SpringImageView()
        image.image = UIImage(named: "question")
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
        button.setTitle("Перейти", for: .normal)
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
        view.addSubviews(hintIcon, titleLabel, okButton)
        titleLabel.text = "Хотите перейти в простой режим приложения?"
        okButton.addTarget(self, action: #selector(goToSimpleMode), for: .touchUpInside)
    }
    
    private func setUpConstraints() {
        
        hintIcon.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(50)
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
            maker.width.equalTo(80)
            maker.height.equalTo(30)
            maker.top.equalTo(titleLabel.snp.bottom).offset(50)
            maker.centerX.equalToSuperview()
        }
    }
}
