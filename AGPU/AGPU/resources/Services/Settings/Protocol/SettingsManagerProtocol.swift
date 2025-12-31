//
//  SettingsManagerProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 22.06.2023.
//

import UIKit

protocol SettingsManagerProtocol {
    func checkCurrentIcon()-> ASPUButtonIconModel
    func checkOnlyMainOption()-> OnlyMainVariants
    func checkSaveRecentTimetableItem()-> Bool
    func checkASPUButtonOption()-> ASPUButtonActions
    func observeASPUButtonActionChanged(completion: @escaping()->Void)
    func checkASPUButtonAnimationOption()-> ASPUButtonAnimationOptions
    func saveCustomSplashScreen(screen: CustomSplashScreenModel)
    func getCustomSplashScreen()-> CustomSplashScreenModel
    func getTabs()-> [TabModel] 
    func getTabsColor()-> TabColors
    func checkTabsAnimationOption()-> Bool
}
