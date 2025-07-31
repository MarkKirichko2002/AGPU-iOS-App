//
//  ForEveryStatusTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 25.07.2023.
//

import UIKit
import SnapKit

final class ForEveryStatusTableViewCell: UITableViewCell {
    
    static let identifier = "ForEveryStatusTableViewCell"
    private let animation = AnimationClass()
    
    private let sectionIcon: SpringImageView = {
        let icon = SpringImageView()
        icon.tintColor = .label
        return icon
    }()
    
    private let sectionName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .black)
        label.textColor = .label
        label.numberOfLines = 0
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
        configureImage(section: section)
        sectionName.text = section.name
    }
    
    private func configureImage(section: ForEveryStatusModel) {
        if isTemplateImage(section: section) {
            updateImageSize(width: 65, height: 65)
            sectionIcon.image = UIImage(data: section.image)?.withRenderingMode(.alwaysTemplate)
        } else {
            updateImageSize(width: 90, height: 90)
            sectionIcon.image = UIImage(data: section.image)?.withRenderingMode(.alwaysOriginal)
        }
        sectionIcon.tintColor = .label
    }
    
    private func updateImageSize(width: CGFloat, height: CGFloat) {
        sectionIcon.snp.updateConstraints { maker in
            maker.width.equalTo(width)
            maker.height.equalTo(height)
        }
    }
    
    private func isTemplateImage(section: ForEveryStatusModel)-> Bool {
        let index = Sections.list.firstIndex { $0.id == section.id }!
        return Sections.list[index].image == section.image
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
            maker.top.equalToSuperview().inset(10)
            maker.left.equalTo(sectionIcon.snp.right).offset(20)
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
