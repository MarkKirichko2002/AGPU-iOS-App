//
//  AGPUNewsServiceProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 08.08.2023.
//

import Foundation

protocol AGPUNewsServiceProtocol {
    func getNews(abbreviation: String) async throws -> Result<NewsResponse, Error>
    func getAGPUNews() async throws -> Result<NewsResponse, Error>
    func getNews(by page: Int, abbreviation: String) async throws -> Result<NewsResponse, Error>
    func urlForCurrentArticle(abbreviation: String, index: Int)-> String
    func urlForCurrentWebPage(abbreviation: String, currentPage: Int)-> String
    func urlForPagination(abbreviation: String, page: Int)-> String
}
