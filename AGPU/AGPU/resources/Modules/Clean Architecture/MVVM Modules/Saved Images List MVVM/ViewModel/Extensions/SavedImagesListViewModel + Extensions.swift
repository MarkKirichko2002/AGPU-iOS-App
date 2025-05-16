//
//  SavedImagesListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 09.05.2024.
//

import Foundation

// MARK: - ISavedImagesListViewModel
extension SavedImagesListViewModel: ISavedImagesListViewModel {
    
    func imagesCount()-> Int {
        return images.count
    }
    
    func imageItem(index: Int)-> ImageModel {
        return images[index]
    }
    
    func saveImage(image: ImageModel) {
        realmManager.saveImage(image: image)
        getImages()
    }
    
    func editImage(image: ImageModel, name: String) {
        realmManager.editImage(image: image, name: name)
        getImages()
    }
    
    func updateImages(images: [ImageModel], _ index: Int, _ index2: Int) {
        realmManager.updateImages(images: images, index, index2)
        getImages()
    }
    
    func deleteImage(image: ImageModel) {
        realmManager.deleteImage(image: image)
        getImages()
    }
    
    func getImages() {
        images = realmManager.getImages()
        dataChangedHandler?()
    }
    
    func getCurrentDate()-> String {
        let date = dateManager.getCurrentDate()
        return date
    }
    
    func createEditAlertMessage()-> (String, String) {
        let style = settingsManager.getSavedCommunicationStyle()
        let name = UserDefaults.standard.string(forKey: "name") ?? ""
        switch style {
        case .formal:
            return ("Изменить изображение", "\(!name.isEmpty ? "\(name) вы точно хотите изменить" : "Вы точно хотите изменить") название изображения?")
        case .informal:
            return ("Изменить изображение", "\(!name.isEmpty ? "\(name) ты точно хочешь изменить" : "Ты точно хочешь изменить") название изображения?")
        }
    }
    
    func registerDataChangedHandler(block: @escaping () -> Void) {
        self.dataChangedHandler = block
    }
}
