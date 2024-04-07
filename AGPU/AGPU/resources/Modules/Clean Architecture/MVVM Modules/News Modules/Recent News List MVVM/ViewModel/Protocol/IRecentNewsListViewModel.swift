//
//  IRecentNewsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 12.03.2024.
//

import Foundation

protocol IRecentNewsListViewModel {
    func articleItem(index: Int)-> Article
    func getNews()
    func resetProgress(id: Int)
    func deleteArticle(id: Int)
    func makeUrlForCurrentArticle(index: Int)-> String
    func registerDataChangedHandler(block: @escaping()->Void)
}
