//
//  ITodayNewsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 25.05.2024.
//

import Foundation

protocol ITodayNewsListViewModel {
    func newsItemAtSection(section: Int, index: Int)-> Article
    func numberOfNewsSections()-> Int
    func getNews()
    func registerDataChangedHandler(block: @escaping()->Void)
}
