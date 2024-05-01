//
//  TabsPositionOptionTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 15.04.2024.
//

import UIKit

class TabsPositionOptionTableViewCell: UITableViewCell {

    static let identifier = "TabsPositionOptionTableViewCell"
    
    var numbers = ["one", "two", "three", "four"]
    var counter = -1
    var tabs = TabsList.tabs
    
    // MARK: - сервисы
    let settingsManager = SettingsManager()
    
    @IBOutlet var TabsPositionOptionIcon: SpringImageView!
    @IBOutlet var TabsPositionOptionName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
        setPosition()
        observeOption()
    }
    
    private func setUpView() {
        TabsPositionOptionIcon.tintColor = .label
        TabsPositionOptionIcon.delegate = self
        TabsPositionOptionName.textColor = .label
        backgroundColor = .systemBackground
        tintColor = .systemGreen
    }
}
