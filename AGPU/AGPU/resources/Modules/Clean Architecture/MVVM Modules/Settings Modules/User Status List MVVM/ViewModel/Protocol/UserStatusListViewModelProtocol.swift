//
//  UserStatusListViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 12.10.2023.
//

import Foundation

protocol UserStatusListViewModelProtocol {
    func statusListCount()-> Int
    func statusItem(index: Int)-> UserStatusModel
    func chooseStatus(index: Int)
    func isStatusSelected(index: Int)-> Bool
}
