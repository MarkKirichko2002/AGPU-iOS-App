//
//  WayTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 13.12.2025.
//

import UIKit
import SnapKit

final class WayTableViewCell: UITableViewCell {
    
    static let identifier = "WayTableViewCell"
    
    private let optionIcon: SpringImageView = {
        let icon = SpringImageView()
        icon.tintColor = .label
        return icon
    }()
    
    private let optionName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .black)
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
    
    func configure(way: differentWays) {
        optionIcon.image = UIImage(named: way.icon)
        optionName.text = way.rawValue
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
            maker.top.equalToSuperview().inset(10)
            maker.left.equalTo(optionIcon.snp.right).offset(20)
            maker.right.equalToSuperview().inset(30)
            maker.bottom.equalToSuperview().inset(10)
        }
    }
}
