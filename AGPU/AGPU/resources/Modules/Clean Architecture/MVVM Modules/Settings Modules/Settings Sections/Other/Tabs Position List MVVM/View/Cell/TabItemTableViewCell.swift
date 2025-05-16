//
//  TabItemTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 23.03.2024.
//

import UIKit
import SnapKit

final class TabItemTableViewCell: UITableViewCell {
    
    static let identifier = "TabItemTableViewCell"
    
    // MARK: - сервисы
    private let settingsManager = SettingsManager()
    
    private let tabIcon: SpringImageView = {
        let icon = SpringImageView()
        icon.tintColor = .label
        return icon
    }()
    
    private let tabName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .black)
        label.textColor = .label
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubviews(tabIcon, tabName)
        customFont()
        customColor()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(tab: TabModel) {
        tabIcon.image = UIImage(data: tab.icon!)?.withRenderingMode(.alwaysTemplate)
        tabName.text = tab.name
    }
    
    private func makeConstraints() {
        
        tabIcon.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(10)
            maker.left.equalToSuperview().inset(20)
            maker.bottom.equalToSuperview().inset(10)
            maker.width.equalTo(65)
            maker.height.equalTo(65)
        }
        
        tabName.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(10)
            maker.left.equalTo(tabIcon.snp.right).offset(20)
            maker.right.equalToSuperview().inset(30)
            maker.bottom.equalToSuperview().inset(10)
        }
    }
    
    func customFont() {
        let savedFont = settingsManager.getTabsFont()
        if savedFont != .none {
            let font = UIFont(name: savedFont.rawValue, size: 16)
            tabName.font = font
        }
    }
    
    func customColor() {
        let savedColor = settingsManager.getTabsColor()
        tabIcon.tintColor = savedColor.color
        tabName.textColor = savedColor.color
    }
}
