//
//  WordRecentDocumentViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 13.08.2023.
//

import Foundation

protocol WordRecentDocumentViewModelProtocol {
    func GetLastPosition(currentUrl: String, completion: @escaping(CGPoint)->Void)
}
