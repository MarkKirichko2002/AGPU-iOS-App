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
        DisciplineName.text = "\(timetable.name) \n\(timetable.teacherName ?? ""), \(timetable.audienceID ?? "") \n (\(timetable.groupName))"
        switch timetable.subgroup {
        case 0:
            SubGroupId.text = ""
        default:
            SubGroupId.text = "(подгруппа: \(timetable.subgroup))"
        }
        let color = pairСolor(type: timetable.type)
        self.backgroundColor = color
    }
    
    private func pairСolor(type: PairType)-> UIColor {
        switch type {
        case .lec:
            return UIColor(named: "lecture")!
        case .prac:
            return UIColor(named: "prac")!
        case .exam:
            return UIColor(named: "exam")!
        case .lab:
            return UIColor(named: "lab")!
        case .hol:
            return UIColor.white
        case .cred:
            return UIColor.white
        case .fepo:
            return UIColor(named: "fepo")!
        case .cons:
            return UIColor.white
        case .none:
            return UIColor.white
        }
    }
    
    func didTapCell(indexPath: IndexPath) {
        animation.SpringAnimation(view: self.TimeLabel)
        animation.SpringAnimation(view: self.DisciplineName)
        animation.SpringAnimation(view: self.SubGroupId)
    }
}
