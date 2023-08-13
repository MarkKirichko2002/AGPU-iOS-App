//
//  WordDocumenReaderViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 13.08.2023.
//

import Foundation

protocol WordDocumenReaderViewModelProtocol {
    func ObserveScroll(completion: @escaping(CGPoint)->Void)
    func ObserveActions(block: @escaping()->Void)
    func SaveCurrentWordDocument(url: String, position: CGPoint)
}
