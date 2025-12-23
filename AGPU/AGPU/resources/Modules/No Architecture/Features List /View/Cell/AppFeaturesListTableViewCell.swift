//
//  AppFeaturesListTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 11.04.2024.
//

import UIKit
import SnapKit

final class AppFeaturesListTableViewCell: UITableViewCell {
    
    static let identifier = "AppFeaturesListTableViewCell"
    
    let featureName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .black)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        tintColor = .systemGreen
        contentView.addSubviews(featureName)
        makeConstraints()
    }
    
    private func makeConstraints() {
        featureName.snp.makeConstraints { maker in
            maker.left.equalToSuperview().inset(20)
            maker.top.equalToSuperview().inset(10)
            maker.bottom.equalToSuperview().inset(10)
        }
    }
    
    func configure(feature: AppFeatureModel) {
        featureName.text = "\(feature.id)) \(feature.name)"
    }
}
