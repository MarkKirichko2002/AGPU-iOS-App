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

    // получить новости факультета
    func getFacultyNews(abbreviation: String, completion: @escaping(Result<NewsResponse, Error>)->Void) {
        
        AF.request("http://\(HostName.host):8080/api/news/\(abbreviation)").responseData { response in
            
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
        
        AF.request("http://\(HostName.host):8080/api/news").responseData { response in
            
            guard let data = response.data else {return}
            
            do {
                let response = try JSONDecoder().decode(NewsResponse.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func getNews(by page: Int, faculty: AGPUFacultyModel?, completion: @escaping(Result<NewsResponse, Error>)->Void) {
        
        let url = urlForPagination(faculty: faculty, page: page)
        
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
    func urlForCurrentArticle(faculty: AGPUFacultyModel?, index: Int)-> String {
        var newsURL = ""
        if faculty != nil {
            newsURL = "http://agpu.net/struktura-vuza/faculties-institutes/\(faculty?.newsAbbreviation ?? "")/news/news.php?ELEMENT_ID=\(index)"
        } else {
            newsURL = "http://agpu.net/news.php?ELEMENT_ID=\(index)"
        }
        return newsURL
    }
    
    // получить URL для пагинации
    func urlForPagination(faculty: AGPUFacultyModel?, page: Int)-> String {
        var url = ""
        if let faculty = faculty {
            url = "http://\(HostName.host):8080/api/news/\(faculty.newsAbbreviation)?page=\(page)"
            print(url)
            return url
        } else {
            url = "http://\(HostName.host):8080/api/news?page=\(page)"
            print(url)
            return url
        }
    }
}
