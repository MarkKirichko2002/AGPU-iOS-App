//
//  AppFeaturesListTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 11.04.2024.
//

import UIKit
import SnapKit

protocol IAppFeaturesListTableViewCell: AnyObject {
    func infoWasTapped()
}

class AppFeaturesListTableViewCell: UITableViewCell {
    
    static let identifier = "AppFeaturesListTableViewCell"
    
    weak var delegate: IAppFeaturesListTableViewCell?
    
    let featureName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .black)
        return label
    }()
    
    let infoButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(named: "info"), for: .normal)
        return button
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
        contentView.addSubviews(featureName, infoButton)
        infoButton.addTarget(self, action: #selector(showInfo), for: .touchUpInside)
        makeConstraints()
    }
    
    private func makeConstraints() {
        
        featureName.snp.makeConstraints { maker in
            maker.left.equalToSuperview().inset(20)
            maker.top.equalToSuperview().inset(10)
            maker.bottom.equalToSuperview().inset(10)
        }
        
        infoButton.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(10)
            maker.right.equalToSuperview().inset(10)
            maker.bottom.equalToSuperview().inset(10)
        }
    }
    
    func configure(feature: AppFeatureModel) {
        featureName.text = "\(feature.id)) \(feature.name)"
    }
    
    @objc private func showInfo() {
        HapticsManager.shared.hapticFeedback()
        delegate?.infoWasTapped()
    }
}
