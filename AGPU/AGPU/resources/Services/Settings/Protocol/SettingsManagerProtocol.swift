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
    func checkOnlyTimetableOption()-> Bool
    func checkSaveRecentTimetableItem()-> Bool
    func observeOnlyTimetableChanged(completion: @escaping()->Void)
    func checkDynamicButtonOption()-> ASPUButtonActions
    func observeDynamicButtonActionChanged(completion: @escaping()->Void)
    func saveCustomSplashScreen(screen: CustomSplashScreenModel)
    func getCustomSplashScreen()-> CustomSplashScreenModel?
    func getUserStatus()-> UserStatusModel
    func observeStatusChanged(completion: @escaping()->Void)
    func getTabsPosition()-> [Int] 
    func observeTabsChanged(completion: @escaping()->Void)
}
