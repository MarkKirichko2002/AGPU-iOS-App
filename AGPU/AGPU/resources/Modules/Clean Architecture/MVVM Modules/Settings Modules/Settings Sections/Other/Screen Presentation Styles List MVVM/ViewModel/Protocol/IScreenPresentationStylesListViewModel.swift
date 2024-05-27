//
//  IScreenPresentationStylesListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 27.05.2024.
//

import Foundation

protocol IScreenPresentationStylesListViewModel {
    func presentationStyleItem(index: Int)-> ScreenPresentationStyles
    func presentationStyleItemsCount()-> Int
    func selectPresentationStyle(index: Int)
    func isPresentationStyleSelected(index: Int)-> Bool
}
