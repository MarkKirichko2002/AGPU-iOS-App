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
    func getNews(abbreviation: String, completion: @escaping(Result<NewsResponse, Error>)->Void) {
        AF.request("http://\(HostName.host)/api/news/\(abbreviation)").responseData { response in
            
            guard let data = response.data else {return}
            
            do {
                let response = try JSONDecoder().decode(NewsResponse.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    // получить новости АГПУ
    func getAGPUNews(completion: @escaping(Result<NewsResponse, Error>)->Void) {
        
        AF.request("http://\(HostName.host)/api/news").responseData { response in
            
            guard let data = response.data else {return}
            
            do {
                let response = try JSONDecoder().decode(NewsResponse.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func getNews(by page: Int, abbreviation: String, completion: @escaping(Result<NewsResponse, Error>)->Void) {
        
        let url = urlForPagination(abbreviation: abbreviation, page: page)
        
        AF.request(url).responseData { response in
            
            guard let data = response.data else {return}
            
            do {
                let response = try JSONDecoder().decode(NewsResponse.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
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
