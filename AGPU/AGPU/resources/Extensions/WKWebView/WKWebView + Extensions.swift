//
//  WKWebView + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 07.07.2023.
//

import WebKit

extension WKWebView {
    
    func load(_ urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            DispatchQueue.main.async {
                self.load(request)
            }
        }
    }
    
    func scrollToUp() {
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 535), animated: true)
    }
    
    func scrollToMiddle() {
        let jsCode = """
                document.querySelector('main').offsetHeight
                """
        self.evaluateJavaScript(jsCode) { result, error in
            if let height = result as? CGFloat {
                print("Высота div: \(height) пикселей")
                let scrollPoint = CGPoint(x: 0, y: (height / 2) + 535)
                self.scrollView.setContentOffset(scrollPoint, animated: true)
            } else if let error = error {
                print("Ошибка JS: \(error)")
            }
        }
    }
    
    func scrollToDown() {
        let jsCode = "document.querySelector('main').offsetHeight"
        self.evaluateJavaScript(jsCode) { result, error in
            if let height = result as? CGFloat {
                print("Высота div: \(height) пикселей")
                let scrollPoint = CGPoint(x: 0, y: (height - height / 4) + 535)
                self.scrollView.setContentOffset(scrollPoint, animated: true)
            } else if let error = error {
                print("Ошибка JS: \(error)")
            }
        }
    }
}
