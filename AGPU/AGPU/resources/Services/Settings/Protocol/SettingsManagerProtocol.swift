//
//  SettingsManagerProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 22.06.2023.
//

import UIKit

protocol SettingsManagerProtocol {
    func checkCurrentIcon()-> ASPUButtonIconModel
    func checkActionToControlOption()-> Bool
    func checkOnlyMainOption()-> OnlyMainVariants
    func observeOnlyMainChangedOption(completion: @escaping()->Void)
    func checkSaveRecentTimetableItem()-> Bool
    func checkASPUButtonOption()-> ASPUButtonActions
    func observeASPUButtonActionChanged(completion: @escaping()->Void)
    func checkASPUButtonAnimationOption()-> ASPUButtonAnimationOptions
    func saveCustomSplashScreen(screen: CustomSplashScreenModel)
    func getCustomSplashScreen()-> CustomSplashScreenModel
    func getTabs()-> [TabModel] 
    func getTabsColor()-> TabColors
    func checkTabsAnimationOption()-> Bool
    func observeTabsChanged(completion: @escaping()->Void)
}
