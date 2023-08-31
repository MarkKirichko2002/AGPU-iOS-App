//
//  WordDocumentReaderViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 13.08.2023.
//

import UIKit
import WebKit

// MARK: - UIScrollViewDelegate
extension WordDocumentReaderViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        let position = CGPoint(x: 0, y: yOffset)
        if let url = WVWEBview.url?.absoluteString {
            self.viewModel.saveCurrentWordDocument(url: url, position: position)
        }
    }
}

// MARK: - WKNavigationDelegate
extension WordDocumentReaderViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        DispatchQueue.main.async {
            self.spinner.startAnimating()
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
        }
    }
}
