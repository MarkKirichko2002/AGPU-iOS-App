//
//  SettingsListViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 21.07.2023.
//

import UIKit

protocol SettingsListViewModelProtocol {
    func facultiesListCount()-> Int
    func facultyItem(index: Int)-> AGPUFacultyModel
    func ChooseFaculty(index: Int)
    func CancelFaculty(index: Int)
    func isFacultySelected(index: Int)-> Bool
    func isFacultySelected(index: Int)-> UITableViewCell.AccessoryType
    func isFacultySelectedColor(index: Int)-> UIColor
}
