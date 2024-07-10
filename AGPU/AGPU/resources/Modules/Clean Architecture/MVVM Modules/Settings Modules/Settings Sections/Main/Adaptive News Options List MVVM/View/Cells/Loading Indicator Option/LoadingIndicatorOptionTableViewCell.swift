//
//  LoadingIndicatorOptionTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 10.07.2024.
//

import UIKit

class LoadingIndicatorOptionTableViewCell: UITableViewCell {

    static let identifier = "LoadingIndicatorOptionTableViewCell"
    
    @IBOutlet var LoadingIndicatorOptionIcon: SpringImageView!
    @IBOutlet var LoadingIndicatorOptionName: UILabel!
    
    func configure(indicator: String) {
        LoadingIndicatorOptionName.text = "Индикатор загрузки (\(indicator))"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        LoadingIndicatorOptionIcon.tintColor = .label
        LoadingIndicatorOptionName.textColor = .label
        backgroundColor = .systemBackground
        tintColor = .systemGreen
    }
}
