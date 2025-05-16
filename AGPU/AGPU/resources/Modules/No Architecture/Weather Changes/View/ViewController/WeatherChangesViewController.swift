//
//  WeatherChangesViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 08.07.2024.
//

import UIKit
import SnapKit

final class WeatherChangesViewController: UIViewController {
    
    var pastWeather: WeatherChangesModel
    var currentWeather: WeatherChangesModel
    
    // MARK: - сервисы
    private let weatherManager = WeatherManager()
    
    // MARK: - UI
    private var closeButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(named: "cross"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let QuestionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Что изменилось в погоде?"
        label.font = .systemFont(ofSize: 18, weight: .black)
        label.textColor = .label
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let DateBefore: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let WeatherIconBefore: SpringImageView = {
        let icon = SpringImageView()
        icon.isInteraction = false
        icon.tintColor = .label
        icon.contentMode = .scaleAspectFill
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    private let WeatherDescriptionBefore: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let DateNow: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let WeatherIconNow: SpringImageView = {
        let icon = SpringImageView()
        icon.image = UIImage(systemName: "sun.max")
        icon.isInteraction = false
        icon.tintColor = .label
        icon.contentMode = .scaleAspectFill
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    private let WeatherDescriptionNow: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Init
    init(pastWeather: WeatherChangesModel, currentWeather: WeatherChangesModel) {
        self.pastWeather = pastWeather
        self.currentWeather = currentWeather
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    private func setUpView() {
        view.backgroundColor = .systemBackground
        setUpCloseButton()
        setUpLabel()
        setUpLeftSide()
        setUpRightSide()
    }
    
    private func setUpCloseButton() {
        view.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(closeScreen), for: .touchUpInside)
        closeButton.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
            maker.right.equalToSuperview().inset(20)
        }
    }
    
    @objc private func closeScreen() {
        self.dismiss(animated: true)
        HapticsManager.shared.hapticFeedback()
    }
    
    private func setUpLabel() {
        view.addSubview(QuestionLabel)
        QuestionLabel.snp.makeConstraints { maker in
            maker.top.equalTo(closeButton.snp.bottom).offset(30)
            maker.left.equalTo(view.snp.left).inset(30)
            maker.right.equalTo(view.snp.right).offset(-30)
        }
    }
    
    private func setUpLeftSide() {
        
        view.addSubviews(DateBefore, WeatherIconBefore, WeatherDescriptionBefore)
        
        DateBefore.text = pastWeather.date
        WeatherIconBefore.image = UIImage(systemName: pastWeather.weather.currentWeather.symbolName)
        WeatherDescriptionBefore.text = "Было: \(Int(pastWeather.weather.currentWeather.temperature.value))°"
        
        DateBefore.snp.makeConstraints { maker in
            maker.top.equalTo(QuestionLabel.snp.bottom).offset(100)
            maker.left.equalTo(view.snp.left).inset(50)
        }
        
        WeatherIconBefore.snp.makeConstraints { maker in
            maker.top.equalTo(DateBefore.snp.bottom).offset(30)
            maker.width.equalTo(100)
            maker.height.equalTo(100)
            maker.left.equalToSuperview().inset(50)
        }
        WeatherDescriptionBefore.snp.makeConstraints { maker in
            maker.top.equalTo(WeatherIconBefore.snp.bottom).offset(30)
            maker.left.equalToSuperview().inset(50)
        }
    }
    
    private func setUpRightSide() {
        
        view.addSubviews(DateNow, WeatherIconNow, WeatherDescriptionNow)
        
        DateNow.text = currentWeather.date
        WeatherIconNow.image = UIImage(systemName: currentWeather.weather.currentWeather.symbolName)
        WeatherDescriptionNow.text = "Стало: \(Int(currentWeather.weather.currentWeather.temperature.value))°"
        
        DateNow.snp.makeConstraints { maker in
            maker.top.equalTo(QuestionLabel.snp.bottom).offset(100)
            maker.right.equalTo(view.snp.right).inset(50)
        }
        
        WeatherIconNow.snp.makeConstraints { maker in
            maker.top.equalTo(DateNow.snp.bottom).offset(30)
            maker.width.equalTo(100)
            maker.height.equalTo(100)
            maker.right.equalToSuperview().inset(50)
        }
        WeatherDescriptionNow.snp.makeConstraints { maker in
            maker.top.equalTo(WeatherIconNow.snp.bottom).offset(30)
            maker.right.equalToSuperview().inset(50)
        }
    }
}
