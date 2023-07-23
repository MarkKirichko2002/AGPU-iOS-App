//
//  TimeTableTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 12.07.2023.
//

import UIKit

final class TimeTableTableViewCell: UITableViewCell {
    
    static let identifier = "TimeTableTableViewCell"
    private let animation = AnimationClass()
    
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
        let color = coupleСolor(name: timetable.name)
        self.backgroundColor = color
    }
    
    private func coupleСolor(name: String)->UIColor {
        switch name {
        case _ where name.contains("экз."):
            return UIColor(named: "exam")!
        case _ where name.contains("лек."):
            return UIColor(named: "lecture")!
        case _ where name.contains("прак."):
            return UIColor(named: "prac")!
        case _ where name.contains("лаб."):
            return UIColor(named: "lab")!
        default:
            return .clear
        }
    }
    
    func didTapCell(indexPath: IndexPath) {
        animation.SpringAnimation(view: self.TimeLabel)
        animation.SpringAnimation(view: self.DisciplineName)
        animation.SpringAnimation(view: self.SubGroupId)
    }
}
