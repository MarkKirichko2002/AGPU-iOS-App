//
//  AGPUFacultiesListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 21.07.2023.
//

import UIKit

// MARK: - AGPUFacultiesListViewModelProtocol
extension AGPUFacultiesListViewModel: AGPUFacultiesListViewModelProtocol {
    
    func facultiesListCount()-> Int {
        return AGPUFaculties.faculties.count
    }
    
    func facultyItem(index: Int)-> AGPUFacultyModel {
        return AGPUFaculties.faculties[index]
    }
    
    func makePhoneNumbersMenu(index: Int) -> UIMenu {
        let faculty = facultyItem(index: index)
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
