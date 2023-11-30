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
        let color = discipline.type.color
        self.backgroundColor = color
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
