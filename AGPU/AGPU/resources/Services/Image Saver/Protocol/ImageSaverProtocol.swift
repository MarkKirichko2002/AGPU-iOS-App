//
//  ImageSaverProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 21.07.2023.
//

import UIKit

protocol ImageSaverProtocol {
    func writeToPhotoAlbum(image: UIImage)
    func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer)
}
