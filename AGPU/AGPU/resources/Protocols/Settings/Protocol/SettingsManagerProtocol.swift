//
//  SettingsManagerProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 22.06.2023.
//

import UIKit

protocol SettingsManagerProtocol {
    func checkCurrentStatus()-> UIViewController
    func checkCurrentIcon()-> String
    func checkShakeToRecallOption()-> Bool
}
