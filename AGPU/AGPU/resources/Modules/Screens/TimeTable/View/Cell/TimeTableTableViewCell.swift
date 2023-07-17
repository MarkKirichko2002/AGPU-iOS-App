//
//  TimeTableTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 12.07.2023.
//

import UIKit

class TimeTableTableViewCell: UITableViewCell {

    static let identifier = "TimeTableTableViewCell"
    
    @IBOutlet var TimeLabel: UILabel!
    @IBOutlet var DisciplineName: UILabel!
    @IBOutlet var SubGroupId: UILabel!
    
    func configure(timetable: TimeTable) {
        TimeLabel.text = timetable.time
        DisciplineName.text = "\(timetable.name ?? "") \(timetable.teacherName ?? "")"
        SubGroupId.text = "подгруппа: \(timetable.subgroup ?? 0)"
    }
}
