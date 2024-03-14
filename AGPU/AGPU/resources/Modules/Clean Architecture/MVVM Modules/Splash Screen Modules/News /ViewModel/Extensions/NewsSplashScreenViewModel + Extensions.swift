//
//  NewsSplashScreenViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 14.03.2024.
//

import Foundation

// MARK: - INewsSplashScreenViewModel
extension NewsSplashScreenViewModel: INewsSplashScreenViewModel {
    
    // получить новости в зависимости от типа
    func getNews() {
        let savedNewsCategory = UserDefaults.standard.object(forKey: "category") as? String ?? "-"
        if savedNewsCategory != "-" {
            getNews(abbreviation: savedNewsCategory)
        } else {
            getAGPUNews()
        }
    }
    
    // получить новости АГПУ
    func getAGPUNews() {
        Task {
            let result = try await newsService.getAGPUNews()
            switch result {
            case .success(let response):
                self.news = response.articles ?? []
                let model = NewsCategoryDescriptionModel(categoryIcon: "АГПУ", categoryName: "АГПУ", newsCount: self.countTodayNews())
                self.newsHandler?(model)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // получить новости
    func getNews(abbreviation: String) {
        let category = NewsCategories.categories.first { $0.newsAbbreviation == abbreviation }
        Task {
            let result = try await newsService.getNews(abbreviation: abbreviation)
            switch result {
            case .success(let response):
                self.news = response.articles ?? []
                let model = NewsCategoryDescriptionModel(categoryIcon: category?.icon ?? "АГПУ", categoryName: category?.name ?? "АГПУ", newsCount: self.countTodayNews())
                self.newsHandler?(model)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func countTodayNews()-> Int {
        let currentDate = dateManager.getCurrentDate()
        var count = 0
        for article in news {
            if article.date == currentDate {
                count += 1
            }
        }
        return count
    }
    
    func registerNewsHandler(block: @escaping(NewsCategoryDescriptionModel)->Void) {
        self.newsHandler = block
    }
}
