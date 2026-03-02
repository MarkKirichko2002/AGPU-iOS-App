//
//  TimetablePseudonymTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 22.10.2025.
//

import UIKit
import SnapKit

final class TimetablePseudonymTableViewCell: UITableViewCell {
    
    static let identifier = "TimetablePseudonymTableViewCell"
    private let animation = AnimationClass()
    
    private let categoryIcon: SpringImageView = {
        let icon = SpringImageView()
        icon.tintColor = .label
        return icon
    }()
    
    private let categoryName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .black)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubviews(categoryIcon, categoryName)
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(for category: PseudonymCategories) {
        categoryIcon.image = UIImage(named: category.icon)
        categoryName.text = category.rawValue
    }
    
    private func makeConstraints() {
        
        categoryIcon.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(10)
            maker.left.equalToSuperview().inset(20)
            maker.bottom.equalToSuperview().inset(10)
            maker.width.equalTo(65)
            maker.height.equalTo(65)
        }
        
        categoryName.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(10)
            maker.left.equalTo(categoryIcon.snp.right).offset(20)
            maker.right.equalToSuperview().inset(30)
            maker.bottom.equalToSuperview().inset(10)
        }
    }
    
    func didTapCell(indexPath: IndexPath, completion: @escaping()->Void) {
        animation.flipAnimation(view: self, option: .transitionFlipFromLeft) {
            HapticsManager.shared.hapticFeedback()
            completion()
        }
    }
}
