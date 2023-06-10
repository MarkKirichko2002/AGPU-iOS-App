//
//  AGPUSubSectionTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 09.06.2023.
//

import UIKit

class AGPUSubSectionTableViewCell: UITableViewCell {
    
    static let identifier = "AGPUSubSectionTableViewCell"
    
    @IBOutlet var AGPUSubSectionTitle: UILabel!
    
    func configure(subsection: AGPUSubSectionModel) {
        AGPUSubSectionTitle.text = subsection.name
    }
    
}
