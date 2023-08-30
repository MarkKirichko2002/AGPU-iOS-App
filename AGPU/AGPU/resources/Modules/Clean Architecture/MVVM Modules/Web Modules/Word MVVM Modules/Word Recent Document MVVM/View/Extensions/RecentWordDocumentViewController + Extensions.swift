//
//  WordRecentDocumentViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 13.08.2023.
//

import WebKit

// MARK: - WKNavigationDelegate
extension WordRecentDocumentViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        DispatchQueue.main.async {
            self.spinner.startAnimating()
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.spinner.stopAnimating()
        if let currentUrl = webView.url?.absoluteString {
            viewModel.getRecentPosition(currentUrl: currentUrl) { position in
                self.WVWEBview.scrollView.setContentOffset(position, animated: true)
            }
        }
    }
}

