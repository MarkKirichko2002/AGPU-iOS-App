//
//  HourlyWeatherCollectionViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 13.02.2024.
//

import UIKit
import SnapKit

class HourlyWeatherCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String {"\(Self.self)"}
    
    private let hourLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let weatherIcon: UIImageView = {
        let icon = UIImageView()
        icon.tintColor = .label
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        hourLabel.text = nil
        weatherIcon.image = nil
        temperatureLabel.text = nil
    }
    
    private func setUpView() {
        contentView.addSubview(hourLabel)
        contentView.addSubview(weatherIcon)
        contentView.addSubview(temperatureLabel)
        makeConstraints()
    }
    
    private func makeConstraints() {
        hourLabel.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(5)
            maker.centerX.equalToSuperview()
        }
        weatherIcon.snp.makeConstraints { maker in
            maker.top.equalTo(hourLabel).inset(20)
            maker.centerX.equalToSuperview()
            maker.width.equalTo(50)
            maker.height.equalTo(50)
        }
        temperatureLabel.snp.makeConstraints { maker in
            maker.top.equalTo(weatherIcon).inset(55)
            maker.centerX.equalToSuperview()
        }
    }
    
    func configure(with model: HourlyWeatherCollectionViewCellViewModel) {
        hourLabel.text = "\(model.hour)"
        weatherIcon.image = UIImage(systemName: model.icon)
        temperatureLabel.text = "\(model.temperature)°"
    }
}
