//
//  AGPUNewsServiceProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 08.08.2023.
//

import Foundation

protocol AGPUNewsServiceProtocol {
    func GetFacultyNews(abbreviation: String, completion: @escaping(Result<[NewsModel], Error>)->Void)
}
