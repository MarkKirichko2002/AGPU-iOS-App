//
//  ForEveryStatusTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 25.07.2023.
//

import UIKit

class ForEveryStatusTableViewCell: UITableViewCell {
    
    static let identifier = "ForEveryStatusTableViewCell"
    
    @IBOutlet var SectionIcon: SpringImageView!
    @IBOutlet var SectionName: UILabel!
    
    func configure(for status: ForEveryStatusModel) {
        SectionIcon.image = UIImage(named: status.icon)
        SectionName.text = status.name
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        SectionIcon.tintColor = .label
        SectionName.textColor = .label
        backgroundColor = .systemBackground
    }
}
