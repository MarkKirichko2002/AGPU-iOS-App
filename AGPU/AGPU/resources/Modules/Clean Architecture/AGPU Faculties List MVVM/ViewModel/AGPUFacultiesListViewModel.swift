//
//  AGPUFacultiesListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 11.07.2023.
//

import UIKit

class AGPUFacultiesListViewModel: NSObject {
    
    @objc dynamic var isChanged = false
    
    var observation: NSKeyValueObservation?
    
    func facultiesListCount()-> Int {
        return AGPUFaculties.faculties.count
    }
    
    func electedFacultyItem(index: Int)-> AGPUFacultyModel {
        return AGPUFaculties.faculties[index]
    }
    
    func ChangeIcon(index: Int) {
        var icon = AGPUFaculties.faculties[index]
        icon.isSelected = true
        UIApplication.shared.setAlternateIconName(icon.appIcon)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            NotificationCenter.default.post(name: Notification.Name("icon"), object: icon)
        }
        UserDefaults.SaveData(object: icon, key: "icon") {
            self.isChanged.toggle()
        }
    }
    
    func isIconSelected(index: Int)-> UITableViewCell.AccessoryType {
        let data = UserDefaults.loadData(type: AGPUFacultyModel.self, key: "icon")
        if data?.id == AGPUFaculties.faculties[index].id && data?.isSelected == true {
            return .checkmark
        } else {
            return .none
        }
    }
    
    func makePhoneNumbersMenu(index: Int) -> UIMenu {
        let faculty = electedFacultyItem(index: index)
        let rateActions = faculty.phoneNumbers
            .map { phone in
                return UIAction(title: phone) { action in
                    self.makePhoneCall(phoneNumber: phone)
                }
            }
        
        return UIMenu(
            title: "позвонить",
            image: UIImage(named: "phone"),
            children: rateActions)
    }
    
    func makePhoneCall(phoneNumber: String) {
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            let application = UIApplication.shared
            if application.canOpenURL(phoneCallURL) {
                application.open(phoneCallURL)
            }
        }
    }
}
