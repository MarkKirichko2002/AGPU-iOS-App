//
//  WKWebView + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 07.07.2023.
//

import WebKit

extension WKWebView {
    
    func load(_ urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            DispatchQueue.main.async {
                self.load(request)
            }
        }
    }
}
