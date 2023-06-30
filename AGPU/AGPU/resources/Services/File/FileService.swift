//
//  FileService.swift
//  AGPU
//
//  Created by Марк Киричко on 30.06.2023.
//

import MobileCoreServices
import UIKit

class FileService: FileServiceProtocol {
    
    weak var delegate: UIDocumentPickerDelegate?
    var vc: UIViewController?
    
    func importFiles() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypeAudio as String], in: .import)
        documentPicker.delegate = delegate
        documentPicker.allowsMultipleSelection = false
        vc?.present(documentPicker, animated: true)
    }
}

