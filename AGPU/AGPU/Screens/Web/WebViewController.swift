//
//  WebViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 11.06.2023.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    private var WVWEBview = WKWebView(frame: .zero)

    var url = URL(string: "http://www.apple.com")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(WVWEBview)
        view = WVWEBview
        WVWEBview.allowsBackForwardNavigationGestures = true
        DispatchQueue.main.async {
            let request = URLRequest(url: self.url!)
            self.WVWEBview.load(request)
        }
        ObserveScroll()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.post(name: Notification.Name("WebScreenWasClosed"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func ObserveScroll() {
        var position = 0
        var scrollPosition = ""
        
        NotificationCenter.default.addObserver(forName: Notification.Name("scroll"), object: nil, queue: .main) { notification in
            scrollPosition = notification.object as? String ?? ""
            
            print(scrollPosition)
            
            if scrollPosition.contains("вверх") {
                position -= 20
            } else if scrollPosition.contains("вниз") {
                position += 20
            }
            
            self.WVWEBview.scrollView.setContentOffset(CGPoint(x: 0, y: position), animated: true)
        }
    }
}
