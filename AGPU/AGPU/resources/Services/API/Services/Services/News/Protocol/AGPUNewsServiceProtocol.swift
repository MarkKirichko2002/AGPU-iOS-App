//
//  AGPUNewsServiceProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 08.08.2023.
//

import Foundation

protocol AGPUNewsServiceProtocol {
    func getFacultyNews(abbreviation: String, completion: @escaping(Result<NewsResponse, Error>)->Void)
    func getAGPUNews(completion: @escaping(Result<NewsResponse, Error>)->Void)
    func getNews(by page: Int, faculty: AGPUFacultyModel?, completion: @escaping(Result<NewsResponse, Error>)->Void)
    func urlForCurrentArticle(faculty: AGPUFacultyModel?, index: Int)-> String
    func urlForPagination(faculty: AGPUFacultyModel?, page: Int)-> String
}
