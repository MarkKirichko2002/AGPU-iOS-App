//
//  SavedVideoTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 02.06.2024.
//

import UIKit
import SnapKit

class SavedVideoTableViewCell: UITableViewCell {
    
    static let identifier = "SavedImageTableViewCell"
    
    private let savedVideoIcon: SpringImageView = {
        let image = SpringImageView()
        image.image = UIImage(named: "play icon")
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
        contentView.addSubviews(savedVideoIcon, dateLabel)
        makeConstraints()
    }
    
    private func makeConstraints() {
        savedVideoIcon.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(10)
            maker.left.equalToSuperview().inset(30)
            maker.bottom.equalToSuperview().inset(10)
            maker.width.equalTo(65)
            maker.height.equalTo(65)
        }
        dateLabel.snp.makeConstraints { maker in
            maker.left.equalTo(savedVideoIcon.snp.right).offset(15)
            maker.top.equalToSuperview().inset(15)
            maker.bottom.equalToSuperview().inset(15)
        }
    }
    
    func configure(video: VideoModel) {
        dateLabel.text = video.name
    }
}
