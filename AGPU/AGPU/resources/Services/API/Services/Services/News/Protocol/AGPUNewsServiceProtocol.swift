//
//  AGPUNewsServiceProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 08.08.2023.
//

import Foundation

protocol AGPUNewsServiceProtocol {
    func getNews(abbreviation: String, completion: @escaping(Result<NewsResponse, Error>)->Void)
    func getAGPUNews(completion: @escaping(Result<NewsResponse, Error>)->Void)
    func getNews(by page: Int, abbreviation: String, completion: @escaping(Result<NewsResponse, Error>)->Void)
    func urlForCurrentArticle(abbreviation: String, index: Int)-> String
    func urlForCurrentWebPage(abbreviation: String, currentPage: Int)-> String
    func urlForPagination(abbreviation: String, page: Int)-> String
}
