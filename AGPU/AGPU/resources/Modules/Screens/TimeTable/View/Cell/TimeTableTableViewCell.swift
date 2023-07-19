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
        layer.borderWidth = 1
        TimeLabel.text = timetable.time
        DisciplineName.text = "\(timetable.name) \n\(timetable.teacherName ?? ""), \(timetable.audienceID ?? "") \n (\(timetable.groupName ?? ""))"
        switch timetable.subgroup {
        case 0:
            SubGroupId.text = ""
        default:
            SubGroupId.text = "(подгруппа: \(timetable.subgroup ?? 0))"
        }
        switch timetable.name {
        case _ where timetable.name.contains("экз"):
            self.backgroundColor = UIColor(named: "exam")
        case _ where timetable.name.contains("лек"):
            self.backgroundColor = UIColor(named: "lecture")
        case _ where timetable.name.contains("прак"):
            self.backgroundColor = UIColor(named: "prac")
        case _ where timetable.name.contains("лаб"):
            self.backgroundColor = UIColor(named: "lab")
        default:
            self.backgroundColor = .clear
        }
    }
}
