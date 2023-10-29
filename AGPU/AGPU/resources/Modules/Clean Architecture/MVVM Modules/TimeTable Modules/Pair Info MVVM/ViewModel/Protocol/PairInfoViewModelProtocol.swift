//
//  PairInfoViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 23.10.2023.
//

import Foundation

protocol PairInfoViewModelProtocol {
    func setUpData()
    func getStartTime()-> String
    func getEndTime()-> String
    func getPairType(type: PairType)-> String
    func checkSubGroup(subgroup: Int)-> String
    func checkIsCurrentGroup(index: Int)-> Bool
    func startTimer()
    func stopTimer()
    func checkCurrentTime()
    func getTimeLeftToStart()
    func getTimeLeftToEnd()
    func registerDataChangedHandler(block: @escaping()->Void)
}