//
//  TimeTableTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 12.07.2023.
//

import UIKit

// MARK: - ITimeTableTableViewCell
protocol ITimeTableTableViewCell: AnyObject {
    func cellTapped(pair: Discipline, id: String, date: String)
}

final class TimeTableTableViewCell: UITableViewCell {
    
    static let identifier = "TimeTableTableViewCell"
    
    // MARK: - сервисы
    private let animation = AnimationClass()
    private let settingsManager = SettingsManager()
    
    weak var delegate: ITimeTableTableViewCell?
    private var pair = Discipline(time: "", name: "", groupName: "", teacherName: "", audienceID: "", subgroup: 0, type: .all)
    private var id = ""
    private var date = ""
    
    @IBOutlet var TimeLabel: UILabel!
    @IBOutlet var DisciplineName: UILabel!
    @IBOutlet var SubGroupId: UILabel!
    
    func configure(timetable: TimeTable, index: Int) {
        setUpDisciplineTime(discipline: timetable.disciplines[index])
        setUpDisciplineName(discipline: timetable.disciplines[index])
        setUpSubGroup(discipline: timetable.disciplines[index])
        setUpCellBackground(discipline: timetable.disciplines[index])
        setUpTimetable(timetable: timetable, index: index)
    }
    
    private func setUpDisciplineTime(discipline: Discipline) {
        TimeLabel.text = discipline.time
    }
    
    private func setUpDisciplineName(discipline: Discipline) {
        DisciplineName.text = "\(discipline.name) \n\(discipline.teacherName), \(discipline.audienceID) \n (\(discipline.groupName)) \n(\(discipline.type.title))"
    }
    
    private func setUpSubGroup(discipline: Discipline) {
        switch discipline.subgroup {
        case 0:
            SubGroupId.text = "Общая пара"
        default:
            SubGroupId.text = "(подгруппа: \(discipline.subgroup))"
        }
    }
    
    private func setUpTimetable(timetable: TimeTable, index: Int) {
        self.pair = timetable.disciplines[index]
        self.id = timetable.id
        self.date = timetable.date
    }
    
    private func setUpCellBackground(discipline: Discipline) {
        layer.borderWidth = 1
        backgroundColor = discipline.type.color
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        TimeLabel.textColor = .black
        DisciplineName.textColor = .black
        SubGroupId.textColor = .black
        backgroundColor = .systemBackground
    }
    
    func didTapCell(indexPath: IndexPath) {
        animation.flipAnimation(view: self, option: .transitionFlipFromLeft) {
            self.delegate?.cellTapped(pair: self.pair, id: self.id, date: self.date)
            HapticsManager.shared.hapticFeedback()
        }
    }
}
