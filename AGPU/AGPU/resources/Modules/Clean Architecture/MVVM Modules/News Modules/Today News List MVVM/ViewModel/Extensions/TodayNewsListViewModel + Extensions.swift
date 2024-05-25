//
//  TodayNewsListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 25.05.2024.
//

import Foundation

// MARK: - ITodayNewsListViewModel
extension TodayNewsListViewModel: ITodayNewsListViewModel {
    
    func newsItemAtSection(section: Int, index: Int)-> Article {
        return sections[section].news[index]
    }
    
    func numberOfNewsSections()-> Int {
        return sections.count
    }
    
    func numberOfNewsInSection(section: Int)-> Int {
        return sections[section].news.count
    }
    
    func titleForHeaderInSection(section: Int)-> String {
        return sections[section].name
    }
    
    func getNews() {
        
        let dispatchGroup = DispatchGroup()
        
        for category in NewsCategories.categories {
            dispatchGroup.enter()
            if category.newsAbbreviation != "-" {
                Task {
                    let result = try await newsService.getNews(abbreviation: category.newsAbbreviation)
                    defer { dispatchGroup.leave() }
                    switch result {
                    case .success(let data):
                        let news = checkTodayNews(news: data.articles ?? [])
                        if !news.isEmpty {
                            let model = TodayNewsSectionModel(name: category.name, abbreviation: category.newsAbbreviation, news: news)
                            sections.append(model)
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            } else {
                Task {
                    let result = try await newsService.getAGPUNews()
                    defer { dispatchGroup.leave() }
                    switch result {
                    case .success(let data):
                        let news = checkTodayNews(news: data.articles ?? [])
                        if !news.isEmpty {
                            let model = TodayNewsSectionModel(name: category.name, abbreviation: category.newsAbbreviation, news: news)
                            sections.append(model)
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.dataChangedHandler?()
        }
    }
    
    func checkTodayNews(news: [Article])-> [Article] {
        let currentDate = dateManager.getCurrentDate()
        var articles = [Article]()
        for article in news {
            if article.date == currentDate {
                articles.append(article)
            }
        }
        return articles
    }
    
    func makeUrlForCurrentArticle(section: Int, index: Int)-> String {
        let url = newsService.urlForCurrentArticle(abbreviation: sections[section].abbreviation, index: newsItemAtSection(section: section, index: index).id)
        return url
    }
        
    func registerDataChangedHandler(block: @escaping()->Void) {
        self.dataChangedHandler = block
    }
}
