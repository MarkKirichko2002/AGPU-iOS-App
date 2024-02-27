//
//  CurrentWeatherTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 13.02.2024.
//

import UIKit
import SnapKit

class CurrentWeatherTableViewCell: UITableViewCell {
    
    static var identifier: String {"\(Self.self)"}
    
    private let weatherIcon: UIImageView = {
        let icon = UIImageView()
        icon.tintColor = .label
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .label
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .label
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let conditionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .label
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let maxMinTemperatureLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .label
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        locationLabel.text = nil
        temperatureLabel.text = nil
        conditionLabel.text = nil
        maxMinTemperatureLabel.text = nil
    }
    
    private func setUpView() {
        contentView.addSubview(weatherIcon)
        contentView.addSubview(locationLabel)
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(conditionLabel)
        contentView.addSubview(maxMinTemperatureLabel)
        makeConstraints()
    }
    
    private func makeConstraints() {
        
        weatherIcon.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.left.equalToSuperview().inset(20)
            maker.width.equalTo(80)
            maker.height.equalTo(80)
        }
        
        locationLabel.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(20)
            maker.centerX.equalToSuperview()
        }
        
        temperatureLabel.snp.makeConstraints { maker in
            maker.top.equalTo(locationLabel).inset(45)
            maker.centerX.equalToSuperview()
        }
        
        conditionLabel.snp.makeConstraints { maker in
            maker.top.equalTo(temperatureLabel).inset(45)
            maker.centerX.equalToSuperview()
        }
        
        maxMinTemperatureLabel.snp.makeConstraints { maker in
            maker.top.equalTo(conditionLabel).inset(45)
            maker.centerX.equalToSuperview()
            maker.bottom.equalToSuperview().inset(20)
        }
    }
    
    func configure(weather: CurrentWeatherTableViewCellViewModel) {
        weatherIcon.image = UIImage(systemName: weather.icon)
        locationLabel.text = weather.location
        temperatureLabel.text = "\(weather.temperature)°"
        conditionLabel.text = weather.condition
        maxMinTemperatureLabel.text = "Макс: \(weather.maxTemperature)°, мин: \(weather.minTemperature)°"
    }
}

