//
//  SavedWebPagesListTableTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 12.04.2025.
//

import UIKit
import SnapKit

final class SavedWebPagesListTableTableViewCell: UITableViewCell {
    
    static let identifier = "SavedWebPagesListTableTableViewCell"
    
    private let savedWebPageIcon: SpringImageView = {
        let image = SpringImageView()
        image.image = UIImage(named: "online")
        image.isInteraction = false
        image.tintColor = .label
        return image
    }()
    
    private let nameLabel: UILabel = {
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
        contentView.addSubviews(savedWebPageIcon, nameLabel)
        makeConstraints()
    }
    
    private func makeConstraints() {
        savedWebPageIcon.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(10)
            maker.left.equalToSuperview().inset(30)
            maker.bottom.equalToSuperview().inset(10)
            maker.width.equalTo(65)
            maker.height.equalTo(65)
        }
        nameLabel.snp.makeConstraints { maker in
            maker.left.equalTo(savedWebPageIcon.snp.right).offset(15)
            maker.top.equalToSuperview().inset(15)
            maker.bottom.equalToSuperview().inset(15)
        }
    }
    
    func configure(page: WebPageModel) {
        nameLabel.text = page.name
    }
}
