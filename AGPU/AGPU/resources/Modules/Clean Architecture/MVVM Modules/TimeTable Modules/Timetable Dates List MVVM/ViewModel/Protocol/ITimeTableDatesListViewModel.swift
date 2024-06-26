//
//  ITimeTableDatesListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 26.06.2024.
//

import UIKit

protocol ITimeTableDatesListViewModel {
    func pairAtSection(section: Int, index: Int)-> Discipline
    func numberOfTimetableSections()-> Int
    func numberOfPairsInSection(section: Int)-> Int
    func titleForHeaderInSection(section: Int)-> String
    func getData()
    func createImage(completion: @escaping(UIImage)->Void)
    func registerDataChangedHandler(block: @escaping()->Void)
}
