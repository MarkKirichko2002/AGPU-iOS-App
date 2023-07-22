//
//  WebViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 06.07.2023.
//

import UIKit
import WebKit

// MARK: - UIScrollViewDelegate
extension WebViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        let position = CGPoint(x: 0, y: yOffset)
        if let url = WVWEBview.url?.absoluteString {
            self.viewModel.SaveCurrentPage(url: url, position: position)
        }
    }
}

// MARK: - WKNavigationDelegate
extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        DispatchQueue.main.async {
            self.spinner.startAnimating()
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Предыдущая страница равна текущей странице перед загрузкой новой страницы
        viewModel.previousPage = viewModel.currentPage
        
        // Сохранение текущего адреса и предыдущей страницы в UserDefaults
        if let currentURL = webView.url?.absoluteString {
            if let previousPage = viewModel.previousPage {
                UserDefaults.standard.set(previousPage, forKey: "previous page")
            }
            
            UserDefaults.standard.set(currentURL, forKey: "last page")
            UserDefaults.standard.synchronize()
            
            viewModel.currentPage = currentURL
        }
        
        print("Последняя посещенная страница: \(viewModel.currentPage ?? "")")
        print("Предыдущая посещенная страница: \(viewModel.previousPage ?? "")")
    }
}
