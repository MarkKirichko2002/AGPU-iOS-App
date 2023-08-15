//
//  DocumentsListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 15.08.2023.
//

import UIKit

// MARK: - DocumentsListViewModelProtocol
extension DocumentsListViewModel: DocumentsListViewModelProtocol {
    
    func GetDocuments() {
        service.ParseDocuments(url: self.url) { documents in
            DispatchQueue.main.async {
                self.documents = documents
                self.docs = documents
                self.dataChangedHandler?()
            }
        }
    }
    
    func registerDataChangedHandler(block: @escaping()->Void) {
        self.dataChangedHandler = block
    }
    
    func makeMenu()-> UIMenu {
        let formats = ["все", "pdf", "doc", "docx"]
        let actions = formats.map { format in
            return UIAction(title: format, state: format == "все" ? .on : .off) { [weak self] _ in
                if format == "все" {
                    guard let self = self else { return }
                    self.documents = self.docs
                    self.dataChangedHandler?()
                } else {
                    guard let self = self else { return }
                    self.documents = self.docs
                    self.documents = self.documents.filter { $0.format.lowercased() == format }
                    self.dataChangedHandler?()
                }
            }
        }
        let menu = UIMenu(title: "форматы", options: .singleSelection, children: actions)
        return menu
    }
    
    func SendScreenClosedNotification() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            NotificationCenter.default.post(name: Notification.Name("screen was closed"), object: nil)
        }
    }
}
