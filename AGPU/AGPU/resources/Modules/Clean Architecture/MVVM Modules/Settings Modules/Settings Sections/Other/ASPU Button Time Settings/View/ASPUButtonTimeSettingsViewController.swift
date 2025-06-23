//
//  ASPUButtonTimeSettingsViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 12.06.2025.
//

import UIKit

final class ASPUButtonTimeSettingsViewController: UIViewController {
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Не прятать кнопку"
        label.isUserInteractionEnabled = true
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timeSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 60
        slider.thumbTintColor = .white
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    // MARK: - сервисы
    private let viewModel: ASPUButtonTimeSettingsViewModel
    
    init(screen: ASPUButtonScreens) {
        self.viewModel = ASPUButtonTimeSettingsViewModel(screen: screen)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpView()
        setUpBackButton()
    }
    
    private func setUpNavigation() {
        let titleView = CustomTitleView(image: "clock", title: viewModel.screen.rawValue, frame: .zero)
        navigationItem.titleView = titleView
    }
    
    private func setUpView() {
        view.backgroundColor = .systemBackground
        view.addSubviews(timeLabel, timeSlider)
        timeLabel.text = viewModel.getCurrentTimeLimitInfo()
        timeSlider.value = Float(viewModel.getSavedTimeLimit())
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            // надпись
            timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timeLabel.widthAnchor.constraint(equalToConstant: 300),
            timeLabel.heightAnchor.constraint(equalToConstant: 90),
            // слайдер
            timeSlider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timeSlider.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            timeSlider.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 60),
            timeSlider.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -60),
            timeSlider.heightAnchor.constraint(equalToConstant: 30),
            timeSlider.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 20)
        ])
    }
    
    func setUpBackButton() {
        
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        let backButton = UIBarButtonItem(customView: button)
        
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        let value = Int(sender.value)
        timeLabel.text = viewModel.configureTime(time: value)
        viewModel.saveTimeLimit(time: value)
    }
}
