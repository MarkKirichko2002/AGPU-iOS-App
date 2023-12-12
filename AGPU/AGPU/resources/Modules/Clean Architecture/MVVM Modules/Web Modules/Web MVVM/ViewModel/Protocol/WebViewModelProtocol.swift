//
//  WebViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 21.07.2023.
//

import Foundation

protocol WebViewModelProtocol {
    func observeScroll(completion: @escaping(CGPoint)->Void)
    func saveCurrentWebPage(url: String, position: CGPoint)
    func observeActions(block: @escaping()->Void)
    func observeSectionSelected(block: @escaping(AGPUSectionModel)->Void) 
}
