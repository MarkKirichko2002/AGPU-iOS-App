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
    
    weak var delegate: ITimeTableTableViewCell?
    private var pair = Discipline(time: "", name: "", groupName: "", teacherName: "", audienceID: "", subgroup: 0, type: .all)
    private var id = ""
    private var date = ""
    
    @IBOutlet var TimeLabel: UILabel!
    @IBOutlet var DisciplineName: UILabel!
    @IBOutlet var SubGroupId: UILabel!
    
    func configure(timetable: TimeTable, index: Int) {
        pair = timetable.disciplines[index]
        layer.borderWidth = 1
        TimeLabel.text = pair.time
        DisciplineName.text = "\(pair.name) \n\(pair.teacherName), \(pair.audienceID) \n (\(pair.groupName)) \n(\(pair.type.title))"
        switch pair.subgroup {
        case 0:
            SubGroupId.text = "Общая пара"
        default:
            SubGroupId.text = "(подгруппа: \(pair.subgroup))"
        }
        self.backgroundColor =  pair.type.color
        TimeLabel.text = pair.time
        self.id = timetable.id
        self.date = timetable.date
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
