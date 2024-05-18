//
//  ForEveryStatusTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 25.07.2023.
//

import UIKit
import SnapKit

class ForEveryStatusTableViewCell: UITableViewCell {
    
    static let identifier = "ForEveryStatusTableViewCell"
    
    private let sectionIcon: SpringImageView = {
        let icon = SpringImageView()
        icon.tintColor = .label
        return icon
    }()
    
    private let sectionName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .black)
        label.textColor = .label
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubviews(sectionIcon, sectionName)
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(for section: ForEveryStatusModel) {
        sectionIcon.image = UIImage(named: section.icon)
        sectionName.text = section.name
    }
    
    private func makeConstraints() {
        
        sectionIcon.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(10)
            maker.left.equalToSuperview().inset(20)
            maker.bottom.equalToSuperview().inset(10)
            maker.width.equalTo(65)
            maker.height.equalTo(65)
        }
        
        sectionName.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(30)
            maker.left.equalTo(sectionIcon.snp.right).offset(20)
            maker.right.equalToSuperview().inset(30)
        }
    }
    
    func sectionSelected(indexPath: IndexPath) {
        let view = UIView()
        view.backgroundColor = .clear
        self.selectedBackgroundView = view
        self.sectionIcon.tintColor = .systemGreen
        self.sectionName.textColor = .systemGreen
    }
}
