//
//  AGPUMainViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 06.07.2023.
//

import WebKit

// MARK: - WKNavigationDelegate
extension AGPUMainViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        spinner.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        spinner.stopAnimating()
    }
}
