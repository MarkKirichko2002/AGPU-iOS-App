//
//  AGPUFacultyTableViewCellDelegate.swift
//  AGPU
//
//  Created by Марк Киричко on 04.02.2024.
//

import Foundation

protocol AGPUFacultyTableViewCellDelegate: AnyObject {
    func openFacultyInfo(faculty: AGPUFacultyModel)
}
