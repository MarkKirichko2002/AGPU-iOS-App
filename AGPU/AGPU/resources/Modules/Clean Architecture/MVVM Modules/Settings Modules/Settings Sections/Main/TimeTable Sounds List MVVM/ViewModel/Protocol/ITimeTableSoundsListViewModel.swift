//
//  ITimeTableSoundsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 02.04.2024.
//

import Foundation

protocol ITimeTableSoundsListViewModel {
    func soundItem(index: Int)-> TimeTableSoundModel
    func numberOfItems()-> Int
    func selectSound(index: Int)
    func saveSound(sound: String)
    func playSound(sound: String)
    func stopSound()
    func isSoundSelected(index: Int)-> Bool
    func registerDataChangedHandler(block: @escaping()->Void)
}
