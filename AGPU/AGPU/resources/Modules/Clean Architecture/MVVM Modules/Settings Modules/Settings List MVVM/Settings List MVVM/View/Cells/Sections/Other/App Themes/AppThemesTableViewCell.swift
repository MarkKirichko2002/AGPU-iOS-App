//
//  AppThemesTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 22.09.2023.
//

import UIKit

class AppThemesTableViewCell: UITableViewCell {

    static let identifier = "AppThemesTableViewCell"
    
    @IBOutlet var ThemeIcon: SpringImageView!
    @IBOutlet var TitleLabel: UILabel!
    
    func configure(theme: AppThemeModel) {
        TitleLabel.text = "текущая тема (\(theme.name))"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ThemeIcon.tintColor = .label
        TitleLabel.textColor = .label
    }
}
