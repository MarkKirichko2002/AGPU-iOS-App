//
//  RecentMomentsListViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 10.08.2023.
//

import Foundation

protocol RecentMomentsListViewModelProtocol {
    func registerAlertHandler(block: @escaping(String, String)->Void)
    func getLastWebPage(completion: @escaping(RecentWebPageModel)->Void)
    func getLastWordDocument(completion: @escaping(RecentWordDocumentModel)->Void)
    func getLastPDFDocument(completion: @escaping(RecentPDFModel)->Void)
    func getLastVideo(completion: @escaping(String)->Void)
}
