//
//  RecentWebPageViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 06.07.2023.
//

import WebKit

// MARK: - WKNavigationDelegate
extension RecentWebPageViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        DispatchQueue.main.async {
            self.spinner.startAnimating()
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if navigationAction.navigationType == .linkActivated, let url = navigationAction.request.url {
                if url.absoluteString.lowercased().hasSuffix(".pdf") {
                    webView.load(URLRequest(url: url))
                    decisionHandler(.cancel)
                    return
                }
            }
            decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.spinner.stopAnimating()
        if let currentUrl = webView.url?.absoluteString {
            viewModel.GetLastPosition(currentUrl: currentUrl) { position in
                self.WVWEBview.scrollView.setContentOffset(position, animated: true)
            }
        }
    }
}
