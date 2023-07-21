//
//  AGPUFacultiesListViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 21.07.2023.
//

import UIKit

protocol AGPUFacultiesListViewModelProtocol {
    func facultiesListCount()-> Int
    func facultyItem(index: Int)-> AGPUFacultyModel
    func makePhoneNumbersMenu(index: Int) -> UIMenu
    func makePhoneCall(phoneNumber: String)
}
