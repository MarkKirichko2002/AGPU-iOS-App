//
//  OnlyTimetableOptionTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 09.12.2023.
//

import UIKit

class OnlyTimetableOptionTableViewCell: UITableViewCell {

    static let identifier = "OnlyTimetableOptionTableViewCell"
    
    var userDefaults = UserDefaults.standard
    let animation = AnimationClass()
    
    @IBOutlet weak var Switch: UISwitch!
    @IBOutlet weak var OnlyTimetableIcon: UIImageView!
    @IBOutlet weak var OnlyTimetableLabel: UILabel!
    
    @IBAction func switchAction(_ sender: UISwitch) {
        
        userDefaults.set(sender.isOn, forKey: "onOnlyTimetable")
        
        if Switch.isOn == true {
            print("on")
            OnlyTimetableIcon.tintColor = .label
            OnlyTimetableLabel.textColor = .label
            userDefaults.set(true, forKey: "onOnlyTimetable")
            animation.springAnimation(view: OnlyTimetableIcon)
            Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false) { _ in
                NotificationCenter.default.post(name: Notification.Name("only timetable"), object: nil)
            }
            AudioPlayerClass.shared.playSound(sound: "paper", isPlaying: false)
        } else if Switch.isOn == false {
            print("off")
            OnlyTimetableIcon.tintColor = .systemGray
            OnlyTimetableLabel.textColor = .systemGray
            userDefaults.set(false, forKey: "onOnlyTimetable")
            Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false) { _ in
                NotificationCenter.default.post(name: Notification.Name("only timetable"), object: nil)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    private func setUpView() {
        OnlyTimetableIcon.tintColor = .label
        backgroundColor = .systemBackground
        OnlyTimetableLabel.textColor = .label
        setUpState()
    }
    
    private func setUpState() {
        let isOnlyTimetable = userDefaults.object(forKey: "onOnlyTimetable") as? Bool ?? false
        Switch.isOn = userDefaults.object(forKey: "onOnlyTimetable") as? Bool ?? false
        OnlyTimetableIcon.tintColor = isOnlyTimetable == true ? .label : .systemGray
        OnlyTimetableLabel.textColor = isOnlyTimetable == true ? .label : .systemGray
    }
}
