//
//  AllWeeksListViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 08.08.2023.
//

import Foundation

protocol AllWeeksListViewModelProtocol {
    func GetWeeks()
    func registerIsChangedHandler(block: @escaping(()->Void))
    func GetCurrentWeek()
    func registerScrollHandler(block: @escaping((Int)->Void))
    func isCurrentWeek(index: Int)-> Bool
}
