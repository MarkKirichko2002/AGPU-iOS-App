//
//  NewsOptionsPostionOptionTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 17.06.2024.
//

import UIKit

class NewsOptionsPostionOptionTableViewCell: UITableViewCell {
    
    static let identifier = "NewsOptionsPostionOptionTableViewCell"
    
    @IBOutlet var NewsOptionsPostionOptionIcon: SpringImageView!
    @IBOutlet var NewsOptionsPostionOptionName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NewsOptionsPostionOptionIcon.tintColor = .label
        NewsOptionsPostionOptionName.textColor = .label
        backgroundColor = .systemBackground
        tintColor = .systemGreen
    }
}
