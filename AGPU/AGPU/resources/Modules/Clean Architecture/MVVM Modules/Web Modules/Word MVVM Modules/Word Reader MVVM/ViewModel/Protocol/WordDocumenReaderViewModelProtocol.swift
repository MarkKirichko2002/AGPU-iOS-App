//
//  WordDocumenReaderViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 13.08.2023.
//

import Foundation

protocol WordDocumenReaderViewModelProtocol {
    func observeScroll(completion: @escaping(CGPoint)->Void)
    func observeActions(block: @escaping()->Void)
    func saveCurrentWordDocument(url: String, position: CGPoint)
}
