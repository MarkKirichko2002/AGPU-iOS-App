//
//  WeekTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 07.08.2023.
//

import UIKit

class WeekTableViewCell: UITableViewCell {
    
    static let identifier = "WeekTableViewCell"
    
    @IBOutlet var WeekID: UILabel!
    @IBOutlet var DateRangeLabel: UILabel!
    
    func configure(week: WeekModel) {
        WeekID.text = "\(week.id)"
        DateRangeLabel.text = "с \(week.from) по \(week.to)"
    }
}
