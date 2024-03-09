//
//  SavedNewsCategoryTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 04.11.2023.
//

import UIKit

class SavedNewsCategoryTableViewCell: UITableViewCell {

    static let identifier = "SavedNewsCategoryTableViewCell"
    
    @IBOutlet var NewsCategoryIcon: SpringImageView!
    @IBOutlet var NewsCategoryName: UILabel!
    
    func configure(category: NewsCategoryModel, viewModel: SavedNewsCategoryViewModel) {
        NewsCategoryIcon.image = UIImage(named: category.icon)
        NewsCategoryName.text = category.name
        NewsCategoryName.textColor = viewModel.isNewsCategorySelected(index: category.id) ? .systemGreen : .label
        accessoryType = viewModel.isNewsCategorySelected(index: category.id) ? .checkmark : .none
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NewsCategoryName.textColor = .label
        backgroundColor = .systemBackground
        tintColor = .systemGreen
    }
}
