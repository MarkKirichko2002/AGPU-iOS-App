//
//  SplashScreensListViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 04.01.2024.
//

import Foundation

protocol SplashScreensListViewModelProtocol {
    func splashScreenOptionItem(index: Int)-> String
    func numberOfSplashScreenOptionsInSection()-> Int
    func chooseSplashScreenOption(index: Int)
    func getStatusInfo()
    func getSelectedFacultyInfo()
    func isCurrentSplashScreenOption(index: Int)-> Bool
    func registerAlertHandler(block: @escaping(String, String)->Void)
    func registerSplashScreenOptionSelectedHandler(block: @escaping(()->Void))
}
