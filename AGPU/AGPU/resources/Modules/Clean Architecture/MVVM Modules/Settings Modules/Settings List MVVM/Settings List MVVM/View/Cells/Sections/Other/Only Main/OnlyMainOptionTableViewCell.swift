//
//  OnlyMainOptionTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 07.05.2024.
//

import UIKit

class OnlyMainOptionTableViewCell: UITableViewCell {

    static let identifier = "OnlyMainOptionTableViewCell"
    
    @IBOutlet var OnlyMainOptionIcon: SpringImageView!
    @IBOutlet var OnlyMainOptionName: UILabel!
    
    func configure(name: String) {
        OnlyMainOptionName.text = name
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        OnlyMainOptionIcon.tintColor = .label
        OnlyMainOptionName.tintColor = .label
    }
}
