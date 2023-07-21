//
//  ImageSaver + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 21.07.2023.
//

import UIKit

// MARK: - ImageSaverProtocol
extension ImageSaver: ImageSaverProtocol {
    
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }

    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save finished!")
    }
}
