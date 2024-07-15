//
//  DailyWeatherTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 13.02.2024.
//

import UIKit

class DailyWeatherTableViewCell: UITableViewCell {
    
    static var identifier: String {"\(Self.self)"}
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.tintColor = .label
        label.font = .systemFont(ofSize: 16, weight: .black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let weatherIcon: UIImageView = {
        let icon = UIImageView()
        icon.tintColor = .label
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    private let maxMinLabel: UILabel = {
        let label = UILabel()
        label.tintColor = .label
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
        dayLabel.text = nil
        weatherIcon.image = nil
        maxMinLabel.text = nil
    }
    
    private func setUpView() {
        contentView.addSubview(dayLabel)
        contentView.addSubview(weatherIcon)
        contentView.addSubview(maxMinLabel)
        makeConstraints()
    }
    
    private func makeConstraints() {
        
        dayLabel.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(10)
            maker.left.equalToSuperview().inset(10)
            maker.bottom.equalToSuperview().inset(10)
        }
        
        weatherIcon.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(20)
            maker.left.equalToSuperview().inset(50)
            maker.height.equalTo(50)
            maker.width.equalTo(50)
        }
        
        maxMinLabel.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(20)
            maker.right.equalToSuperview().inset(10)
            maker.bottom.equalToSuperview().inset(20)
            maker.height.equalTo(50)
        }
    }
    
    func configure(with viewModel: DailyWeatherTableViewCellViewModel) {
        dayLabel.text = viewModel.dayOfWeek
        weatherIcon.image = UIImage(systemName: viewModel.weatherIcon)
        maxMinLabel.text = "мин: \(viewModel.minTemperature)°, макс: \(viewModel.maxTemperature)°"
    }
}
