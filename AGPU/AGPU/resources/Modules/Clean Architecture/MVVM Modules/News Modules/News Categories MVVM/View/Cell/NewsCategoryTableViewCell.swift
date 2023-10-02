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
        if category.pagesCount != 0 {
            CategoryName.text = "\(category.name) (страниц: \(category.pagesCount))"
        } else {
            CategoryName.text = "\(category.name) (загрузка...)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        CategoryName.textColor = .label
        backgroundColor = .systemBackground
    }
}
