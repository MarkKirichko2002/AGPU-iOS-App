//
//  AGPUNewsService + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 08.08.2023.
//

import Alamofire
import Foundation

// MARK: - AGPUNewsServiceProtocol
extension AGPUNewsService: AGPUNewsServiceProtocol {

    // получить новости
    func getNews(abbreviation: String) async throws -> Result<NewsResponse, Error> {
        
        let url = URL(string: "http://\(domain)/api/news/\(abbreviation)")!
        let request = URLRequest(url: url)
        
        let data = try await session.data(for: request)
        
        do {
            let news = try JSONDecoder().decode(NewsResponse.self, from: data.0)
            return .success(news)
        } catch {
            return .failure(error)
        }
    }
    
    // получить новости АГПУ
    func getAGPUNews() async throws -> Result<NewsResponse, Error> {
        
        let url = URL(string: "http://\(domain)/api/news")!
        let request = URLRequest(url: url)
        
        let data = try await session.data(for: request)
        
        do {
            let news = try JSONDecoder().decode(NewsResponse.self, from: data.0)
            return .success(news)
        } catch {
            return .failure(error)
        }
    }
    
    func getNews(by page: Int, abbreviation: String) async throws -> Result<NewsResponse, Error> {
        
        let url = URL(string: urlForPagination(abbreviation: abbreviation, page: page))!
        
        let request = URLRequest(url: url)
        
        let data = try await session.data(for: request)
        
        do {
            let news = try JSONDecoder().decode(NewsResponse.self, from: data.0)
            return .success(news)
        } catch {
            return .failure(error)
        }
    }
    
    func getArticleInfo(abbreviation: String, id: Int) async throws -> Result<ArticleInfo, Error> {
        
        var url = ""
        
        if abbreviation != "-" {
            url = "http://\(HostName.host)/api/news/\(abbreviation)/\(id)"
        } else {
            url = "http://\(HostName.host)/api/news/agpu/\(id)"
        }
        
        let request = URLRequest(url: URL(string: url)!)
        
        let data = try await session.data(for: request)
        
        do {
            let news = try JSONDecoder().decode(ArticleInfo.self, from: data.0)
            return .success(news)
        } catch {
            return .failure(error)
        }
    }
    
    // получить URL для конкретной статьи
    func urlForCurrentArticle(abbreviation: String, index: Int)-> String {
        
        var newsURL = ""
        
        if abbreviation == "-"  {
            newsURL = "https://agpu.net/news.php?ELEMENT_ID=\(index)"
        } else if abbreviation == "educationaltechnopark" {
            newsURL = "https://www.agpu.net/struktura-vuza/educationaltechnopark/news/news.php?ELEMENT_ID=\(index)"
        } else if abbreviation == "PedagogicalQuantorium"  {
            newsURL = "https://www.agpu.net/struktura-vuza/PedagogicalQuantorium/news/news.php?ELEMENT_ID=\(index)"
        } else {
            newsURL = "https://agpu.net/struktura-vuza/faculties/\(abbreviation)/news/news.php?ELEMENT_ID=\(index)"
        }
        
        return newsURL
    }
    
    // получить URL для конкретной веб-страницы
    func urlForCurrentWebPage(abbreviation: String, currentPage: Int)-> String {
        if abbreviation == "-" {
            return "https://www.agpu.net/news.php?PAGEN_1=\(currentPage)"
        } else if abbreviation == "PedagogicalQuantorium" {
            return "https://www.agpu.net/struktura-vuza/PedagogicalQuantorium/news/news.php?PAGEN_1=\(currentPage)"
        } else if abbreviation == "educationaltechnopark" {
            return "https://www.agpu.net/struktura-vuza/educationaltechnopark/news/news.php?PAGEN_1=\(currentPage)"
        } else if abbreviation != "-" {
            return "https://www.agpu.net/struktura-vuza/faculties-institutes/\(abbreviation)/news/news.php?PAGEN_1=\(currentPage)"
        }
        return "https://www.agpu.net/news.php?PAGEN_1=\(currentPage)"
    }
    
    // получить URL для пагинации
    func urlForPagination(abbreviation: String, page: Int)-> String {
        var url = ""
        if abbreviation != "-" {
            url = "http://\(domain)/api/news/\(abbreviation)?page=\(page)"
            print(url)
            return url
        } else {
            url = "http://\(domain)/api/news?page=\(page)"
            print(url)
            return url
        }
    }
}
