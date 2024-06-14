//
//  INewsWebViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 06.03.2024.
//

import Foundation

protocol INewsWebViewModel {
    func saveArticlePosition(position: Double)
    func getPosition()
    func saveCurrentWebArticle(url: String, position: CGPoint)
    func getCategoryIcon(url: String)-> String
    func registerScrollPositionHandler(block: @escaping(Double)->Void)
}
