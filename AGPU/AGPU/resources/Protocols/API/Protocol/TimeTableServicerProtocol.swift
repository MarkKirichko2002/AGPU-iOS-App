//
//  TimeTableServicerProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 12.07.2023.
//

import Foundation

protocol TimeTableServicerProtocol {
    func GetAllGroups(completion: @escaping ([GroupModel]) -> Void)
    func GetTimeTable(groupId: String, date: String, completion: @escaping(Result<[TimeTable],Error>)->Void)
}
