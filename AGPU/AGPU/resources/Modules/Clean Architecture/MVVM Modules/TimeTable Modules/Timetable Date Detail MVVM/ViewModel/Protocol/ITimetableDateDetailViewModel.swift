//
//  ITimetableDateDetailViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 24.02.2024.
//

import UIKit

protocol ITimetableDateDetailViewModel {
    func getTimeTableForDay()
    func getTimeTableForSearch(id: String, owner: String)
    func getImage(json: Codable, completion: @escaping(UIImage)->Void)
    func getPairsCount()-> Int
    func textColor()-> UIColor
    func filterPairs(type: PairType)
    func filterLeftedPairs(pairs: [Discipline])-> [Discipline]
    func formattedDate()-> String
    func saveImageToList()
    func registerTimeTableHandler(block: @escaping(TimeTableDateModel)->Void)
}
