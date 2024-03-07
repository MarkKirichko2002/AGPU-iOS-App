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
    func registerScrollPositionHandler(block: @escaping(Double)->Void)
}
