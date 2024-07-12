//
//  SettablePersonalityOptionTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 12.07.2024.
//

import UIKit
import SnapKit

class SettablePersonalityOptionTableViewCell: UITableViewCell {
    
    static let identifier = "SettablePersonalityOptionTableViewCell"
    
    private let optionIcon: SpringImageView = {
        let icon = SpringImageView()
        icon.tintColor = .label
        return icon
    }()
    
    private let optionName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .black)
        label.numberOfLines = 0
        label.textColor = .label
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubviews(optionIcon, optionName)
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(option: PersonalityOptionModel) {
        optionIcon.image = UIImage(named: option.icon)
        optionName.text = option.name
    }
    
    private func makeConstraints() {
        
        optionIcon.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(10)
            maker.left.equalToSuperview().inset(20)
            maker.bottom.equalToSuperview().inset(10)
            maker.width.equalTo(65)
            maker.height.equalTo(65)
        }
        
        optionName.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(30)
            maker.left.equalTo(optionIcon.snp.right).offset(20)
            maker.right.equalToSuperview().inset(30)
            maker.bottom.equalToSuperview().inset(30)
        }
    }
}
