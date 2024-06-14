//
//  WebViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 21.07.2023.
//

import Foundation

protocol WebViewModelProtocol {
    func saveCurrentWebPage(url: String, position: CGPoint)
    func saveCurrentWebArticle(url: String, position: CGPoint)
    func checkWebType(url: String, position: CGPoint)
    func checkWebPage(url: String)
    func getCategoryIcon(url: String)-> String
    func observeActions(block: @escaping(Actions)->Void)
    func observeSectionSelected(block: @escaping(AGPUSectionModel)->Void) 
    func observeSubSectionSelected(block: @escaping(AGPUSubSectionModel)->Void)
    func observeScroll(completion: @escaping(CGPoint)->Void)
}
