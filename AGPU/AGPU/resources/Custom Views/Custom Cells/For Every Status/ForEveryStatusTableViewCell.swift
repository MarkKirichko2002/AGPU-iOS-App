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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        SectionIcon.image = nil
        SectionName.text = nil
        SectionName.textColor = .label
        SectionIcon.tintColor = .label
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        SectionIcon.tintColor = .label
        SectionName.textColor = .label
        backgroundColor = .systemBackground
    }
    
    func sectionSelected(indexPath: IndexPath) {
        let view = UIView()
        view.backgroundColor = .clear
        self.selectedBackgroundView = view
        self.SectionIcon.tintColor = .systemGreen
        self.SectionName.textColor = .systemGreen
    }
}
