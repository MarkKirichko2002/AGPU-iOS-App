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
    
    func GetFacultyNews(abbreviation: String, completion: @escaping(Result<NewsResponse, Error>)->Void) {
        
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
    
    func GetAGPUNews(completion: @escaping(Result<NewsResponse, Error>)->Void) {
        
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
}
