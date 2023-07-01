//
//  FileService + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 02.07.2023.
//

import MobileCoreServices
import UIKit

// MARK: - FileServiceProtocol
extension FileService: FileServiceProtocol {
    
    func importFiles() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypeAudio as String], in: .import)
        documentPicker.delegate = delegate
        documentPicker.allowsMultipleSelection = false
        vc?.present(documentPicker, animated: true)
    }
}
