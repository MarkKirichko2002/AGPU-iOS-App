//
//  SavedImageTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 09.05.2024.
//

import UIKit
import SnapKit

class SavedImageTableViewCell: UITableViewCell {
    
    static let identifier = "SavedImageTableViewCell"
    
    private let savedImage: SpringImageView = {
        let image = SpringImageView()
        image.isInteraction = false
        image.tintColor = .label
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private let dateLabel: UILabel = {
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
        contentView.addSubviews(savedImage, dateLabel)
        makeConstraints()
        setUpImage()
    }
    
    private func setUpImage() {
        savedImage.clipsToBounds = true
        savedImage.layer.cornerRadius = 8
        savedImage.layer.borderWidth = 2
        savedImage.layer.borderColor = UIColor.label.cgColor
        savedImage.isInteraction = false
    }
    
    private func makeConstraints() {
        savedImage.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(10)
            maker.left.equalToSuperview().inset(30)
            maker.bottom.equalToSuperview().inset(10)
            maker.width.equalTo(100)
            maker.height.equalTo(100)
        }
        dateLabel.snp.makeConstraints { maker in
            maker.left.equalTo(savedImage.snp.right).offset(15)
            maker.top.equalToSuperview().inset(15)
            maker.bottom.equalToSuperview().inset(15)
        }
    }
    
    func configure(image: ImageModel) {
        savedImage.image = UIImage(data: image.image)
        dateLabel.text = image.date
    }
}
