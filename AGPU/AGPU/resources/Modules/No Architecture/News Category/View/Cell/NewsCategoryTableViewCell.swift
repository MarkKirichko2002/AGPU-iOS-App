//
//  NewsCategoryTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 17.08.2023.
//

import UIKit

class NewsCategoryTableViewCell: UITableViewCell {
    
    static let identifier = "NewsCategoryTableViewCell"
    
    @IBOutlet var CategoryIcon: SpringImageView!
    @IBOutlet var CategoryName: UILabel!
    
    func configure(category: NewsCategoryModel) {
        CategoryIcon.image = UIImage(named: category.icon)
        CategoryName.text = category.name
    }
}
