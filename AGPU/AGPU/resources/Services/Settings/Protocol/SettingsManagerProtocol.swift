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
    func checkASPUButtonOption()-> ASPUButtonActions
    func observeASPUButtonActionChanged(completion: @escaping()->Void)
    func checkASPUButtonAnimationOption()-> ASPUButtonAnimationOptions
    func saveCustomSplashScreen(screen: CustomSplashScreenModel)
    func getCustomSplashScreen()-> CustomSplashScreenModel
    func getUserStatus()-> UserStatusModel
    func observeStatusChanged(completion: @escaping()->Void)
    func getTabsPosition()-> [Int] 
    func getTabsColor()-> Colors
    func checkTabsAnimationOption()-> Bool
    func observeTabsChanged(completion: @escaping()->Void)
}
