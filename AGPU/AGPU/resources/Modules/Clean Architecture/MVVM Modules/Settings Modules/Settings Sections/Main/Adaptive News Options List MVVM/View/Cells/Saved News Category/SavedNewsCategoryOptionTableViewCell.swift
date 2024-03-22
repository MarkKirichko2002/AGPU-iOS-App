//
//  SavedNewsCategoryOptionTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 22.03.2024.
//

import UIKit

class SavedNewsCategoryOptionTableViewCell: UITableViewCell {

    static let identifier = "SavedNewsCategoryOptionTableViewCell"
    
    @IBOutlet var NewsCategoryOptionIcon: SpringImageView!
    @IBOutlet var NewsCategoryOptionName: UILabel!
    
    func configure(category: String) {
        NewsCategoryOptionName.text = "категория: \(category)"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NewsCategoryOptionIcon.tintColor = .label
        NewsCategoryOptionName.textColor = .label
        backgroundColor = .systemBackground
        tintColor = .systemGreen
    }
}
