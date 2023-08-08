//
//  AGPUNewsListViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 08.08.2023.
//

import Foundation

protocol AGPUNewsListViewModelProtocol {
    func GetNews()
    func registerDataChangedHandler(block: @escaping(AGPUFacultyModel)->Void)
    func ObserveFacultyChanges()
}
