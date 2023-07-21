//
//  AGPUNewsViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 21.07.2023.
//

import Foundation

protocol AGPUNewsViewModelProtocol {
    var dateHandler: ((String)->Void)? {get set}
    func registerDateHandler(block: @escaping(String)->Void)
    func GetDate()
    func registerScrollHandler(completion: @escaping(CGPoint)->Void)
    func registerFacultyHandler(completion: @escaping(AGPUFacultyModel?)->Void)
}
