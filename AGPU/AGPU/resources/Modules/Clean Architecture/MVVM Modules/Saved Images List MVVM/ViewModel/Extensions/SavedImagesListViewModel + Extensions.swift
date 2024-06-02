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
    
    func getImages() {
        images = realmManager.getImages()
        dataChangedHandler?()
    }
    
    func deleteImage(image: ImageModel) {
        realmManager.deleteImage(image: image)
        getImages()
    }
    
    func getCurrentDate()-> String {
        let date = dateManager.getCurrentDate()
        return date
    }
    
    func registerDataChangedHandler(block: @escaping () -> Void) {
        self.dataChangedHandler = block
    }
}
