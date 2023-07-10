//
//  RecentPageViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 06.07.2023.
//

import WebKit

// MARK: - WKNavigationDelegate
extension RecentPageViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        DispatchQueue.main.async {
            self.spinner.startAnimating()
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.spinner.stopAnimating()
        if let page = UserDefaults.loadData(type: RecentPageModel.self, key: "last page") {
            if webView.url?.absoluteString == page.url {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.WVWEBview.scrollView.setContentOffset(page.position, animated: true)
                }
            }
        }
    }
}
