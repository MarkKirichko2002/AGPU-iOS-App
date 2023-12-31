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
            if url.pathExtension == "pdf" {
                let vc = PDFDocumentReaderViewController(url: url.absoluteString)
                let navVC = UINavigationController(rootViewController: vc)
                navVC.modalPresentationStyle = .fullScreen
                DispatchQueue.main.async {
                    self.present(navVC, animated: true)
                }
                decisionHandler(.cancel)
                return
            }
            if url.pathExtension == "doc" || url.pathExtension == "docx" {
                let vc = WordDocumentReaderViewController(url: url.absoluteString)
                let navVC = UINavigationController(rootViewController: vc)
                navVC.modalPresentationStyle = .fullScreen
                DispatchQueue.main.async {
                    self.present(navVC, animated: true)
                }
                decisionHandler(.cancel)
                return
            }
        }
        decisionHandler(.allow)
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
extension RecentWebPageViewController: UIScrollViewDelegate {

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("прокрутка завершилась")
        HapticsManager.shared.hapticFeedback()
        scrollView.isUserInteractionEnabled = true
    }
}
