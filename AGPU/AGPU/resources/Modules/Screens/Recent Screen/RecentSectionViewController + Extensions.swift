//
//  RecentSectionViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 06.07.2023.
//

import WebKit

// MARK: - WKNavigationDelegate
extension RecentSectionViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let position = UserDefaults.loadData(type: CGPoint.self, key: "last position") {
            DispatchQueue.main.async {
                self.WVWEBview.scrollView.setContentOffset(position, animated: true)
            }
        }
    }
}
