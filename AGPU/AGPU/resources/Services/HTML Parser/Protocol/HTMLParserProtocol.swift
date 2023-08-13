//
//  HTMLParserProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 13.08.2023.
//

import Foundation

protocol HTMLParserProtocol {
    func ParseDocuments(url: String, completion: @escaping([DocumentModel])->Void)
}
