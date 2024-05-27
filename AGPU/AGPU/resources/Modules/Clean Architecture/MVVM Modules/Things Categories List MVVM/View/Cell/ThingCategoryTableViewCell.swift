//
//  ThingCategoryTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 28.05.2024.
//

import UIKit
import SnapKit

class ThingCategoryTableViewCell: UITableViewCell {
    
    static let identifier = "ThingCategoryTableViewCell"
    
    private let categoryIcon: SpringImageView = {
        let image = SpringImageView()
        image.isInteraction = false
        image.tintColor = .label
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private let categoryName: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .black)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        contentView.addSubviews(categoryIcon, categoryName)
        makeConstraints()
    }
    
    private func makeConstraints() {
        categoryIcon.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(10)
            maker.left.equalToSuperview().inset(30)
            maker.bottom.equalToSuperview().inset(10)
            maker.width.equalTo(65)
            maker.height.equalTo(65)
        }
        categoryName.snp.makeConstraints { maker in
            maker.left.equalTo(categoryIcon.snp.right).offset(15)
            maker.top.equalToSuperview().inset(15)
            maker.bottom.equalToSuperview().inset(15)
        }
    }
    
    func configure(category: ThingCategoryModel) {
        categoryIcon.image = UIImage(named: category.icon)
        categoryName.text = "\(category.name) (\(category.itemsCount))"
    }
}
