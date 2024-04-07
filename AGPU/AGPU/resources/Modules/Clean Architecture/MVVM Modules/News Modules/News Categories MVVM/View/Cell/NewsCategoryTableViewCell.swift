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
        displayCategoryInfo(category: category)
        accessoryType = viewModel.isCurrentCategory(index: category.id) ? .checkmark : .none
    }
    
    private func displayCategoryInfo(category: NewsCategoryModel) {
        if category.pagesCount < 0 {
            PagesCount.text = "Страниц: ..."
        } else {
            PagesCount.text = "Страниц: \(category.pagesCount)"
        }
        if category.dailyNewsCount < 0 {
            DailyNewsCount.text = "Сегодня новостей: ..."
        } else {
            DailyNewsCount.text = "Сегодня новостей: \(category.dailyNewsCount)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        CategoryName.textColor = .label
        backgroundColor = .systemBackground
        tintColor = .systemGreen
    }
}
