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
                if position.y > 0 {
                    webView.scrollView.setContentOffset(position, animated: true)
                } else {
                    webView.scrollView.isUserInteractionEnabled = true
                }
            }
        }
    }
}

// MARK: - UIScrollViewDelegate
extension WordRecentDocumentViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("прокрутка завершилась")
        HapticsManager.shared.hapticFeedback()
        scrollView.isUserInteractionEnabled = true
    }
}
