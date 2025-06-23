//
//  TimetableDayInfoViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 17.05.2025.
//

import UIKit

protocol TimetableDayInfoViewControllerDelegate: AnyObject {
    func buttonWasTapped()
}

final class TimetableDayInfoViewController: UIViewController {
    
    // MARK: - UI
    private var closeButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(named: "cross"), for: .normal)
        return button
    }()
    
    private let timetableIcon: SpringImageView = {
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
    
    // MARK: - сервисы
    private let viewModel = TimetableDayInfoViewModel()
    
    weak var delegate: TimetableDayInfoViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpConstraints()
        bindViewModel()
    }
        
    private func setUpView() {
        view.backgroundColor = .systemBackground
        view.addSubviews(closeButton, timetableIcon, titleLabel, okButton)
        okButton.addTarget(self, action: #selector(closeScreen), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeScreen), for: .touchUpInside)
    }
    
    @objc private func closeScreen() {
        delegate?.buttonWasTapped()
        viewModel.saveCurrentDate()
        HapticsManager.shared.hapticFeedback()
        dismiss(animated: true)
    }
            
    private func setUpConstraints() {
        
        closeButton.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
            maker.right.equalToSuperview().inset(20)
        }
        
        timetableIcon.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.width.equalTo(70)
            maker.height.equalTo(70)
        }
        
        titleLabel.snp.makeConstraints { maker in
            maker.top.equalTo(timetableIcon.snp.bottom).offset(60)
            maker.left.equalToSuperview().inset(30)
            maker.right.equalToSuperview().inset(30)
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview()
        }
        
        okButton.snp.makeConstraints { maker in
            maker.width.equalTo(80)
            maker.height.equalTo(30)
            maker.top.equalTo(titleLabel.snp.bottom).offset(50)
            maker.centerX.equalToSuperview()
        }
    }
    
    func bindViewModel() {
        viewModel.registerInfoHandler { date, count in
            DispatchQueue.main.async {
                self.titleLabel.text = "\(date)\n\n\nСегодня пар: \(count)"
            }
        }
        viewModel.getTimetableDayInfo()
    }
}
