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
    
    // получить новости по факультету
    func getNews(abbreviation: String) async throws -> Result<NewsResponse, Error> {
        let parser = NewsParser()
        do {
            let response = try await parser.getArticlesByFaculty(faculty: abbreviation, page: 1)
            return .success(response)
        } catch {
            return .failure(error)
        }
    }
    
    // получить новости АГПУ
    func getAGPUNews() async throws -> Result<NewsResponse, Error> {
        let parser = NewsParser()
        do {
            let response = try await parser.getAgpuNews(page: 1)
            return .success(response)
        } catch {
            return .failure(error)
        }
    }
    
    // получить новости по странице и факультету
    func getNews(by page: Int, abbreviation: String) async throws -> Result<NewsResponse, Error> {
        let parser = NewsParser()
        do {
            let response = try await parser.getArticlesByFaculty(faculty: abbreviation, page: page)
            return .success(response)
        } catch {
            return .failure(error)
        }
    }
    
    // получить информацию о конкретной статье
    func getArticleInfo(abbreviation: String, id: Int) async throws -> Result<ArticleInfo, Error> {
        let parser = NewsParser()
        do {
            let article: ArticleInfo
            if abbreviation == "-" {
                article = try await parser.getArticleById(faculty: "-", id: id)
            } else {
                article = try await parser.getArticleById(faculty: abbreviation, id: id)
            }
            return .success(article)
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
