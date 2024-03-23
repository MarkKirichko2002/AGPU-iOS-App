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
    @IBOutlet var PagesCount: UILabel!
    @IBOutlet var DailyNewsCount: UILabel!
    
    func configure(viewModel: NewsCategoriesListViewModel, category: NewsCategoryModel) {
        CategoryIcon.image = UIImage(named: category.icon)
        CategoryName.text = category.name
        PagesCount.text = "Страниц: \(category.pagesCount)"
        DailyNewsCount.text = "Сегодня новостей: \(category.dailyNewsCount)"
        accessoryType = viewModel.isCurrentCategory(index: category.id) ? .checkmark : .none
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        CategoryName.textColor = .label
        backgroundColor = .systemBackground
        tintColor = .systemGreen
    }
}
