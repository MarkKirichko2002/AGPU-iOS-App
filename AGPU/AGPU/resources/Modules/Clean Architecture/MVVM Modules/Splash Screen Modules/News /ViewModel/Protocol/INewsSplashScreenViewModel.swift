//
//  INewsSplashScreenViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 14.03.2024.
//

import Foundation

protocol INewsSplashScreenViewModel {
    func getNews()
    func getAGPUNews()
    func getNews(abbreviation: String)
    func countTodayNews()-> Int
    func registerNewsHandler(block: @escaping(NewsCategoryDescriptionModel)->Void)
}
