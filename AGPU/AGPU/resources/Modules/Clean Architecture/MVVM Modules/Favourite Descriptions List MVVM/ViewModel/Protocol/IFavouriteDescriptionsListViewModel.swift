//
//  IFavouriteDescriptionsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 23.09.2025.
//

import Foundation

protocol IFavouriteDescriptionsListViewModel {
    func descriptionsCount()-> Int
    func descriptionItem(index: Int)-> String
    func addDescription(description: String)
    func getDescriptions()
    func updateDescriptions(descriptions: [String], _ index: Int, _ index2: Int)
    func loadDescriptions()-> [String]
    func deleteDescription(description: String)
    func saveArray(array: [String])
    func registerDataChangedHandler(block: @escaping()->Void)
}
