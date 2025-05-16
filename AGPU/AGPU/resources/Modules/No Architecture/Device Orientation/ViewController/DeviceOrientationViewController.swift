//
//  DeviceOrientationViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 08.02.2025.
//

import UIKit

protocol DeviceOrientationViewControllerDelegate: AnyObject {
    func getTimetable(date: String)
}

protocol DeviceOrientationViewControllerWeekDelegate: AnyObject {
    func getTimetable(week: WeekModel)
}

final class DeviceOrientationViewController: UIViewController {
    
    // MARK: - UI
    private var closeButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(named: "cross"), for: .normal)
        return button
    }()
    
    private let hintIcon: SpringImageView = {
        let image = SpringImageView()
        image.image = UIImage(named: "clock")
        image.tintColor = .label
        image.isUserInteractionEnabled = true
        return image
    }()
    
    private let orientationLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    private let okButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.setTitle("Увидеть", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .black)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    var isWeek: Bool = false
    var date: String = ""
    var week = WeekModel(id: 0, from: "", to: "", dayNames: [:])
    weak var dayDelegate: DeviceOrientationViewControllerDelegate?
    weak var weekDelegate: DeviceOrientationViewControllerWeekDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpUI()
        setUpConstraints()
    }
    
    private func setUpView() {
        view.backgroundColor = .systemBackground
        view.addSubviews(closeButton, hintIcon, orientationLabel, questionLabel, okButton)
        okButton.addTarget(self, action: #selector(getTimetable), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeScreen), for: .touchUpInside)
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        dismiss(animated: true)
    }
    
    @objc private func getTimetable() {
        if isWeek {
            weekDelegate?.getTimetable(week: week)
        } else {
            dayDelegate?.getTimetable(date: date)
        }
        HapticsManager.shared.hapticFeedback()
        dismiss(animated: true)
    }
            
    private func setUpConstraints() {
        
        closeButton.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
            maker.right.equalToSuperview().inset(20)
        }
        
        hintIcon.snp.makeConstraints { maker in
            maker.top.equalTo(closeButton.snp.bottom).offset(20)
            maker.centerX.equalToSuperview()
            maker.width.equalTo(75)
            maker.height.equalTo(75)
        }
        
        orientationLabel.snp.makeConstraints { maker in
            maker.top.equalTo(hintIcon.snp.bottom).offset(60)
            maker.left.equalToSuperview().inset(30)
            maker.right.equalToSuperview().inset(30)
            maker.centerX.equalToSuperview()
        }
        
        questionLabel.snp.makeConstraints { maker in
            maker.top.equalTo(orientationLabel.snp.bottom).offset(50)
            maker.left.equalToSuperview().inset(30)
            maker.right.equalToSuperview().inset(30)
            maker.centerX.equalToSuperview()
        }
        
        okButton.snp.makeConstraints { maker in
            maker.width.equalTo(80)
            maker.height.equalTo(30)
            maker.top.equalTo(questionLabel.snp.bottom).offset(50)
            maker.centerX.equalToSuperview()
        }
    }
    
    func setUpUI() {
        if isWeek {
            orientationLabel.text = "Неделя: \(week.id)"
            questionLabel.text = "Показать расписание?"
        } else {
            orientationLabel.text = date
            questionLabel.text = "Показать расписание?"
        }
    }
}
