//
//  AGPUNewsViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 06.07.2023.
//

import WebKit

// MARK: - WKNavigationDelegate
extension AGPUNewsViewController: WKNavigationDelegate {
    
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
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
        }
    }
}
