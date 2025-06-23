//
//  IGlanceInfoOptionsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 17.06.2025.
//

import Foundation

protocol IGlanceInfoOptionsListViewModel {
    func getAllData()
    func observeOptionSelection()
    func registerDataChangedHandler(block: @escaping()->Void)
}
