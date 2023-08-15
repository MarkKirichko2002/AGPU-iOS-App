//
//  DocumentsListViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 15.08.2023.
//

import UIKit

protocol DocumentsListViewModelProtocol {
    func GetDocuments()
    func registerDataChangedHandler(block: @escaping()->Void)
    func makeMenu()-> UIMenu
    func SendScreenClosedNotification()
}
