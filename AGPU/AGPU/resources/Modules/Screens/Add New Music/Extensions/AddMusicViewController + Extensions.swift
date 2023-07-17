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
                music.duration = AudioPlayer.shared.getAudioDuration(url: sandboxFileURL)!
            } catch {
                print("Ошибка: \(error)")
            }
        }
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension AddMusicViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        
        self.image = image
        print(self.image)
    }
}
