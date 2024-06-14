//
//  NewsWebViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 06.03.2024.
//

import UIKit
import WebKit

// MARK: - UIScrollViewDelegate
extension NewsWebViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let yOffset = scrollView.contentOffset.y
        if !decelerate {
            viewModel.saveArticlePosition(position: yOffset)
            if let url = WVWEBview.url?.absoluteString {
                self.viewModel.saveCurrentWebArticle(url: url, position: scrollView.contentOffset)
            }
            print("scrolling...")
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("прокрутка завершилась")
        HapticsManager.shared.hapticFeedback()
        scrollView.isUserInteractionEnabled = true
    }
}

// MARK: - WKNavigationDelegate
extension NewsWebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        if let url = webView.url?.absoluteString {
            self.spinner.image = UIImage(named: viewModel.getCategoryIcon(url: url))
        }
        
        DispatchQueue.main.async {
            self.animation.startRotateAnimation(view: self.spinner)
            self.spinner.isHidden = false
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.animation.stopRotateAnimation(view: self.spinner)
        self.spinner.isHidden = true
        viewModel.registerScrollPositionHandler{ position in
            print(position)
            if position > 0 && webView.url?.absoluteString == self.url {
                DispatchQueue.main.async {
                    webView.scrollView.setContentOffset(CGPoint(x: 0, y: position), animated: true)
                }
            } else {
                webView.scrollView.isUserInteractionEnabled = true
            }
        }
        viewModel.getPosition()
    }
}
