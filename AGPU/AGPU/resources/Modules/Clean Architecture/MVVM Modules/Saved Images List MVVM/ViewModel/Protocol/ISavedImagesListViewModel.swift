//
//  ISavedImagesListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 09.05.2024.
//

import Foundation

protocol ISavedImagesListViewModel {
    func imagesCount()-> Int
    func imageItem(index: Int)-> ImageModel
    func getImages()
    func deleteImage(image: ImageModel)
    func registerDataChangedHandler(block: @escaping()->Void)
}
