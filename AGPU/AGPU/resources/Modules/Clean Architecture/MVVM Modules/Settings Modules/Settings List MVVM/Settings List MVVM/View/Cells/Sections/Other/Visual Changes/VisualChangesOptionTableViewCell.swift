//
//  VisualChangesOptionTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 26.05.2024.
//

import UIKit

final class VisualChangesOptionTableViewCell: UITableViewCell {

    static let identifier = "VisualChangesOptionTableViewCell"
    
    var userDefaults = UserDefaults.standard
    var animation = AnimationClass()
    
    @IBOutlet weak var Switch: UISwitch!
    @IBOutlet weak var VisualChangesIcon: UIImageView!
    @IBOutlet weak var VisualChangesLabel: UILabel!
    
    @IBAction func switchAction(_ sender: UISwitch) {
        
        userDefaults.set(sender.isOn, forKey: "onVisualChanges")
        
        if Switch.isOn == true {
            print("on")
            VisualChangesIcon.tintColor = .label
            VisualChangesLabel.textColor = .label
            userDefaults.set(true, forKey: "onVisualChanges")
            animation.springAnimation(view: VisualChangesIcon)
            NotificationCenter.default.post(name: Notification.Name("visual changes option"), object: nil)
        } else if Switch.isOn == false {
            print("off")
            VisualChangesIcon.tintColor = .systemGray
            VisualChangesLabel.textColor = .systemGray
            userDefaults.set(false, forKey: "onVisualChanges")
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    private func setUpView() {
        VisualChangesIcon.tintColor = .label
        backgroundColor = .systemBackground
        VisualChangesLabel.textColor = .label
        setUpState()
    }
    
    private func setUpState() {
        let isVisualChanges = userDefaults.object(forKey: "onVisualChanges") as? Bool ?? false
        Switch.isOn = isVisualChanges
        VisualChangesIcon.tintColor = isVisualChanges == true ? .label : .systemGray
        VisualChangesLabel.textColor = isVisualChanges == true ? .label : .systemGray
    }
}
