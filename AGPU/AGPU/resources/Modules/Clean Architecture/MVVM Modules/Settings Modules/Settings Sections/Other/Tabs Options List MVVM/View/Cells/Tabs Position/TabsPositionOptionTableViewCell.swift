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
    var counter = 0
    
    @IBOutlet var TabsPositionOptionIcon: SpringImageView!
    @IBOutlet var TabsPositionOptionName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        TabsPositionOptionIcon.tintColor = .label
        TabsPositionOptionIcon.delegate = self
        TabsPositionOptionName.textColor = .label
        backgroundColor = .systemBackground
        tintColor = .systemGreen
    }
}

// MARK: - SpringImageViewDelegate
extension TabsPositionOptionTableViewCell: SpringImageViewDelegate {
    
    func imageWasTapped() {
        if counter < 3 {
            counter += 1
            TabsPositionOptionIcon.image = UIImage(named: numbers[counter])
        } else {
            counter = 0
            TabsPositionOptionIcon.image = UIImage(named: numbers[counter])
        }
    }
}
