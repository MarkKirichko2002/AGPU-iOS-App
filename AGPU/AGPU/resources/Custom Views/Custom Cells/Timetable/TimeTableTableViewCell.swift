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
        let discipline = timetable.disciplines[index]
        layer.borderWidth = 1
        TimeLabel.text = discipline.time
        DisciplineName.text = "\(discipline.name) \n\(discipline.teacherName), \(discipline.audienceID) \n (\(discipline.type.title))"
        switch discipline.subgroup {
        case 0:
            SubGroupId.text = ""
        default:
            SubGroupId.text = "(подгруппа: \(discipline.subgroup))"
        }
        let color = isEnded(date: timetable.date, time: discipline.time.components(separatedBy: "-")[1]) ? .gray : discipline.type.color
        self.backgroundColor = color
        self.TimeLabel.text = self.isEnded(date: timetable.date, time: discipline.time.components(separatedBy: "-")[1]) ? "(завершено)" : discipline.time
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        TimeLabel.textColor = .black
        DisciplineName.textColor = .black
        SubGroupId.textColor = .black
        backgroundColor = .systemBackground
    }
    
    func isEnded(date: String, time: String)-> Bool  {
        
        let currentTime = DateManager().getCurrentTime()
        let currentDate = DateManager().getCurrentDate()
        
        let compareTime = DateManager().compareTimes(time1: "\(time):00", time2: currentTime)
        let compareDate = DateManager().compareDates(date1: date, date2: currentDate)
        
        // прошлый день
        if compareDate == .orderedAscending {
            return true
        }
        
        // время меньше и тот же день
        if compareTime == .orderedAscending && compareDate == .orderedSame {
            return true
        }
        
        // время такое же и тот же день
        if compareTime == .orderedSame && compareDate == .orderedSame  {
            return true
        }
        
        return false
    }
    
    func didTapCell(indexPath: IndexPath) {
        animation.springAnimation(view: self.TimeLabel)
        animation.springAnimation(view: self.DisciplineName)
        animation.springAnimation(view: self.SubGroupId)
        HapticsManager.shared.hapticFeedback()
    }
}
