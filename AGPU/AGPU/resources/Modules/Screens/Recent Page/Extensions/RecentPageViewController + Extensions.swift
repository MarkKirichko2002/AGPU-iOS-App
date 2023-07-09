//
//  RecentPageViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 06.07.2023.
//

import WebKit

// MARK: - WKNavigationDelegate
extension RecentPageViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let page = UserDefaults.loadData(type: RecentPageModel.self, key: "last page") {
            DispatchQueue.main.async {
                self.WVWEBview.scrollView.setContentOffset(page.position, animated: true)
            }
        }
    }
}
