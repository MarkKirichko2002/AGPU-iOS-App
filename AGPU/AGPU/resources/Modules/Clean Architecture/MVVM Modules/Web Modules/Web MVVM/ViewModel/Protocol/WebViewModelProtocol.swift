//
//  WebViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 21.07.2023.
//

import Foundation

protocol WebViewModelProtocol {
    func ObserveScroll(completion: @escaping(CGPoint)->Void)
    func ObserveActions(block: @escaping()->Void)
    func SaveCurrentWebPage(url: String, position: CGPoint)
}
