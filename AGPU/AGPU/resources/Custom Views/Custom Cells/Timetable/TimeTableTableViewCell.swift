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
    
    func configure(timetable: TimeTable, index: Int) {
        layer.borderWidth = 1
        TimeLabel.text = timetable.disciplines[index].time
        DisciplineName.text = "\(timetable.disciplines[index].name) \n\(timetable.disciplines[index].teacherName), \(timetable.disciplines[index].audienceID) \n (\(pairType(type: timetable.disciplines[index].type)))"
        switch timetable.disciplines[index].subgroup {
        case 0:
            SubGroupId.text = ""
        default:
            SubGroupId.text = "(подгруппа: \(timetable.disciplines[index].subgroup))"
        }
        let color = pairСolor(type: timetable.disciplines[index].type)
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
            return UIColor.white
        case .cons:
            return UIColor.white
        case .none:
            return UIColor.white
        case .all:
            return UIColor.white
        }
    }
    
    private func pairType(type: PairType)-> String {
        switch type {
        case .lec:
            return "лекция"
        case .prac:
            return "практика"
        case .exam:
            return "экзамен"
        case .lab:
            return "лабораторная работа"
        case .hol:
            return "каникулы"
        case .cred:
            return "зачет"
        case .fepo:
            return "ФЭПО"
        case .cons:
            return "консультация"
        case .none:
            return "другое"
        case .all:
            return ""
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        TimeLabel.textColor = .black
        DisciplineName.textColor = .black
        SubGroupId.textColor = .black
        backgroundColor = .systemBackground
    }
    
    func didTapCell(indexPath: IndexPath) {
        animation.springAnimation(view: self.TimeLabel)
        animation.springAnimation(view: self.DisciplineName)
        animation.springAnimation(view: self.SubGroupId)
        HapticsManager.shared.hapticFeedback()
    }
}
