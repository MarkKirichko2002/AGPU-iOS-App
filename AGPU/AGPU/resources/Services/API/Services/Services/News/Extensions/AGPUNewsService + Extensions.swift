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
    
    func GetFacultyNews(abbreviation: String, completion: @escaping(Result<[NewsModel], Error>)->Void) {
        
        AF.request("http://195.43.142.74:8080/api/news/\(abbreviation)").responseData { response in
            
            guard let data = response.data else {return}
            
            do {
                let news = try JSONDecoder().decode([NewsModel].self, from: data)
                completion(.success(news))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
