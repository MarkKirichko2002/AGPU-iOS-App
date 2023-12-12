//
//  WebViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 21.07.2023.
//

import UIKit

protocol WebViewModelProtocol {
    func observeScroll(scrollView: UIScrollView, completion: @escaping(CGPoint)->Void)
    func saveCurrentWebPage(url: String, position: CGPoint)
    func observeActions(block: @escaping(Actions)->Void)
    func observeSectionSelected(block: @escaping(AGPUSectionModel)->Void) 
}
