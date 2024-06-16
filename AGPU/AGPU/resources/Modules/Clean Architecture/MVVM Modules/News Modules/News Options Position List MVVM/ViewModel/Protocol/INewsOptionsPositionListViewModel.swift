//
//  INewsOptionsPositionListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 16.06.2024.
//

import Foundation

protocol INewsOptionsPositionListViewModel {
    func getData()
    func saveNewsOptionsPosition(_ index: Int, _ index2: Int)
    func registerDataChangedHandler(block: @escaping()->Void)
}
