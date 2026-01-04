//
//  SelectedBuildingsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 02.01.2026.
//

import Foundation

final class SelectedBuildingsListViewModel {
    
    var buildings = AGPUBuildings.buildings.map({ $0.name })
    var selectedBuildings = [String]()
    
    var dataChangedHandler: (()->Void)?
    
    // MARK: - сервисы
    private let settingsManager = SettingsManager()
    
    func getBuildings() {
        selectedBuildings = settingsManager.loadBuildings()
        dataChangedHandler?()
    }
    
    func buildingtem(index: Int)-> String {
        return buildings[index]
    }
    
    func buildingsCount()-> Int {
        return buildings.count
    }
    
    func selectBuilding(index: Int) {
        let building = buildings[index]
        if selectedBuildings.contains(building) {
            let index = selectedBuildings.firstIndex { $0 == building }!
            selectedBuildings.remove(at: index)
        } else {
            selectedBuildings.append(building)
        }
        saveBuildings(buildings: selectedBuildings)
    }
    
    func isBuildingSelected(index: Int)-> Bool {
        let building = buildingtem(index: index)
        return selectedBuildings.contains(building)
    }
    
    func saveBuildings(buildings: [String]) {
        do {
            let arr = try JSONEncoder().encode(buildings)
            UserDefaults.standard.setValue(arr, forKey: "selected buildings")
            HapticsManager.shared.hapticFeedback()
            getBuildings()
        } catch {
            print(error)
        }
    }
    
    func checkScreen(screen: ASPUButtonScreens)-> Bool {
        let screens = settingsManager.loadASPUButtonScreens()
        return screens.contains(screen)
    }
    
    func registerDataChangedHandler(block: @escaping()->Void) {
        self.dataChangedHandler = block
    }
}

