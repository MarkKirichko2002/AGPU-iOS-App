//
//  AllSectionsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 24.09.2024.
//

import Foundation

final class AllSectionsListViewModel {
    
    var itemSelectedHandler: (()->Void)?
    
    func sectionsCount()-> Int {
        return Sections.list.count
    }
    
    func sectionItem(index: Int)-> ForEveryStatusModel {
        let section = Sections.list[index]
        return section
    }
    
    func selectSection(index: Int) {
        let section = sectionItem(index: index)
        saveSection(section: section)
    }
    
    func saveSection(section: ForEveryStatusModel) {
        var sections = loadSections()
        if !sections.contains(where: { $0.id == section.id }) {
            sections.append(section)
        }
        saveArray(array: sections)
    }
    
    func saveSections(sections: [ForEveryStatusModel]) {
        var savedSections = loadSections()
        for section in sections {
            if !savedSections.contains(where: { $0.id == section.id }) {
                savedSections.append(section)
            }
        }
        saveArray(array: savedSections)
    }
    
    func loadSections()-> [ForEveryStatusModel] {
        var data = [ForEveryStatusModel]()
        if let result = UserDefaults.standard.object(forKey: "sections") as? Data {
            do {
                data = try JSONDecoder().decode([ForEveryStatusModel].self, from: result)
            } catch {
                print(error)
            }
        }
        return data
    }
    
    func saveArray(array: [ForEveryStatusModel]) {
        do {
            let arr = try JSONEncoder().encode(array)
            UserDefaults.standard.setValue(arr, forKey: "sections")
            UserDefaults.standard.setValue(arr, forKey: "recent sections")
            HapticsManager.shared.hapticFeedback()
        } catch {
            print(error)
        }
        itemSelectedHandler?()
    }
    
    func registerItemSelectedHandler(block: @escaping()->Void) {
        self.itemSelectedHandler = block
    }
}
