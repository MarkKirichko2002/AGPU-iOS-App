//
//  TimeTableServicerProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 12.07.2023.
//

import Foundation

protocol TimeTableServicerProtocol {
    func GetAllGroups(completion: @escaping([String: [String]])->Void)
    func GetTimeTable(groupId: String, date: String, completion: @escaping([TimeTable])->Void)
}