//
//  AddMusicViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 30.06.2023.
//

import UIKit

// MARK: - UIDocumentPickerDelegate
extension AddMusicViewController: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
       
        guard let selectedFileURL = urls.first else {
            return
        }
        
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let sandboxFileURL = dir.appendingPathComponent(selectedFileURL.lastPathComponent)
        
        if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
          
            do {
                print("уже есть")
                music.fileName = "\(sandboxFileURL)"
            } catch {
                print(error)
            }
            
        } else {
            
            do {
                print("copied file")
                try FileManager.default.copyItem(at: selectedFileURL, to: sandboxFileURL)
                music.fileName = "\(sandboxFileURL)"
            } catch {
                print("Ошибка: \(error)")
            }
        }
    }
}
