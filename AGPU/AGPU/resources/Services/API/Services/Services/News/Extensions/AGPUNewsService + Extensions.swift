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
        
        let url = URL(string: "http://\(HostName.host)/api/news/\(abbreviation)")!
        let request = URLRequest(url: url)
        
        let data = try await URLSession.shared.data(for: request)
        
        do {
            let news = try JSONDecoder().decode(NewsResponse.self, from: data.0)
            return .success(news)
        } catch {
            return .failure(error)
        }
    }
    
    // получить новости АГПУ
    func getAGPUNews() async throws -> Result<NewsResponse, Error> {
        
        let url = URL(string: "http://\(HostName.host)/api/news")!
        let request = URLRequest(url: url)
        
        let data = try await URLSession.shared.data(for: request)
        
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
        
        let data = try await URLSession.shared.data(for: request)
        
        do {
            let news = try JSONDecoder().decode(NewsResponse.self, from: data.0)
            return .success(news)
        } catch {
            return .failure(error)
        }
    }
    
    // получить URL для конкретной статьи
    func urlForCurrentArticle(abbreviation: String, index: Int)-> String {
        
        var newsURL = ""
        
        if abbreviation == "-"  {
            newsURL = "http://agpu.net/news.php?ELEMENT_ID=\(index)"
        } else if abbreviation == "educationaltechnopark" {
            newsURL = "http://www.agpu.net/struktura-vuza/educationaltechnopark/news/news.php?ELEMENT_ID=\(index)"
        } else if abbreviation == "PedagogicalQuantorium"  {
            newsURL = "http://www.agpu.net/struktura-vuza/PedagogicalQuantorium/news/news.php?ELEMENT_ID=\(index)"
        } else if let faculty = AGPUFaculties.faculties.first(where: { $0.newsAbbreviation == abbreviation }) {
            newsURL = "http://agpu.net/struktura-vuza/faculties-institutes/\(faculty.newsAbbreviation)/news/news.php?ELEMENT_ID=\(index)"
        }
        
        return newsURL
    }
    
    // получить URL для конкретной веб-страницы
    func urlForCurrentWebPage(abbreviation: String, currentPage: Int)-> String {
        if abbreviation == "-" {
            return "http://www.agpu.net/news.php?PAGEN_1=\(currentPage)"
        } else if abbreviation == "PedagogicalQuantorium" {
            return "http://www.agpu.net/struktura-vuza/PedagogicalQuantorium/news/news.php?PAGEN_1=\(currentPage)"
        } else if abbreviation == "educationaltechnopark" {
            return "http://www.agpu.net/struktura-vuza/educationaltechnopark/news/news.php?PAGEN_1=\(currentPage)"
        } else if abbreviation != "-" {
            return "http://www.agpu.net/struktura-vuza/faculties-institutes/\(abbreviation)/news/news.php?PAGEN_1=\(currentPage)"
        }
        return "http://www.agpu.net/news.php?PAGEN_1=\(currentPage)"
    }
    
    // получить URL для пагинации
    func urlForPagination(abbreviation: String, page: Int)-> String {
        var url = ""
        if abbreviation != "-" {
            url = "http://\(HostName.host)/api/news/\(abbreviation)?page=\(page)"
            print(url)
            return url
        } else {
            url = "http://\(HostName.host)/api/news?page=\(page)"
            print(url)
            return url
        }
    }
}
