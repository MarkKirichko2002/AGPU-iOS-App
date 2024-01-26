//
//  TimetableSettingsListViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 19.11.2023.
//

import UIKit

protocol TimetableSettingsListViewModelProtocol {
    func getAllData()
    func getSavedFaculty()-> AGPUFacultyModel?
    func getSavedOwner()-> String
    func currentOwnerIcon()-> String
    func currentOwnerScreen()-> UIViewController
    func getSavedGroup()-> String
    func getSavedSubGroup()-> Int
    func getSavedPairType()-> PairType
    func observeOptionSelection()
    func registerDataChangedHandler(block: @escaping()->Void)
}
