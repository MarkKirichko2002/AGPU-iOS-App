//
//  RecentMomentsListViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 10.08.2023.
//

import Foundation

protocol RecentMomentsListViewModelProtocol {
    func GetLastWebPage(completion: @escaping(RecentWebPageModel)->Void)
    func GetLastPDFDocument(completion: @escaping(RecentPDFModel)->Void)
    func GetLastVideo(completion: @escaping(String)->Void)
}