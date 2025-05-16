//
//  IBuildingsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 11.05.2024.
//

import MapKit

protocol IBuildingsListViewModel {
    func buildingItem(index: Int)-> BuildingModel
    func buildingItemsCountInSection()-> Int
    func selectBuilding(index: Int)
    func isBuildingSelected(index: Int)-> Bool
    func registerSelectedHandler(block: @escaping()->Void)
}
