//
//  SettingsManagerProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 22.06.2023.
//

import UIKit

protocol SettingsManagerProtocol {
    func observeStatusChanged(completion: @escaping()->Void)
    func checkCurrentStatus()-> UIViewController
    func checkCurrentIcon()-> String
    func checkShakeToRecallOption()-> Bool
    func checkOnlyTimetableOption()-> Bool
    func checkSaveRecentTimetableItem()-> Bool 
    func observeOnlyTimetableChanged(completion: @escaping()->Void)
}
