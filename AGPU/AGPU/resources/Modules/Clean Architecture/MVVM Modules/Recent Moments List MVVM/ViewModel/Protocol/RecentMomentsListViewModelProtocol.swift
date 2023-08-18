//
//  RecentMomentsListViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 10.08.2023.
//

import Foundation

protocol RecentMomentsListViewModelProtocol {
    func registerAlertHandler(block: @escaping(String, String)->Void)
    func GetLastWebPage(completion: @escaping(RecentWebPageModel)->Void)
    func GetLastWordDocument(completion: @escaping(RecentWordDocumentModel)->Void)
    func GetLastPDFDocument(completion: @escaping(RecentPDFModel)->Void)
    func GetLastVideo(completion: @escaping(String)->Void)
    func SendScreenClosedNotification()
}
