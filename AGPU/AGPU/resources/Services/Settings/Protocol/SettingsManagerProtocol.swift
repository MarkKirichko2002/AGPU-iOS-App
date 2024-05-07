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
    func checkOnlyMainOption()-> OnlyMainVariants
    func observeOnlyMainChangedOption(completion: @escaping()->Void)
    func checkSaveRecentTimetableItem()-> Bool
    func checkASPUButtonOption()-> ASPUButtonActions
    func observeASPUButtonActionChanged(completion: @escaping()->Void)
    func checkASPUButtonAnimationOption()-> ASPUButtonAnimationOptions
    func saveCustomSplashScreen(screen: CustomSplashScreenModel)
    func getCustomSplashScreen()-> CustomSplashScreenModel
    func getUserStatus()-> UserStatusModel
    func observeStatusChanged(completion: @escaping()->Void)
    func getTabsPosition()-> [Int] 
    func getTabsColor()-> TabColors
    func checkTabsAnimationOption()-> Bool
    func observeTabsChanged(completion: @escaping()->Void)
}
