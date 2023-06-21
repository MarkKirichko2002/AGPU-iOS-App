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

    var url: URL

    // MARK: - Init
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(WVWEBview)
        view = WVWEBview
        WVWEBview.allowsBackForwardNavigationGestures = true
        DispatchQueue.main.async {
            let request = URLRequest(url: self.url)
            self.WVWEBview.load(request)
        }
        SetUpNavigation()
        ObserveScroll()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.post(name: Notification.Name("WebScreenWasClosed"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func SetUpNavigation() {
        let backbutton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(backButtonTapped))
        backbutton.tintColor = .black
        let forwardbutton = UIBarButtonItem(image: UIImage(systemName: "arrow.forward"), style: .plain, target: self, action: #selector(forwardButtonTapped))
        forwardbutton.tintColor = .black
        let closebutton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeButtonTapped))
        closebutton.tintColor = .black
        self.navigationItem.rightBarButtonItems = [forwardbutton, backbutton]
        self.navigationItem.leftBarButtonItem = closebutton
    }
    
    @objc private func backButtonTapped() {
        if WVWEBview.canGoBack {
            WVWEBview.goBack()
        }
    }
    
    @objc private func forwardButtonTapped() {
        if WVWEBview.canGoForward {
            WVWEBview.goForward()
        }
    }
    
    @objc private func closeButtonTapped() {
        self.dismiss(animated: true)
    }
    
    private func ObserveScroll() {
        var position = 0
        var scrollPosition = ""
        
        NotificationCenter.default.addObserver(forName: Notification.Name("scroll"), object: nil, queue: .main) { notification in
            scrollPosition = notification.object as? String ?? ""
            
            print(scrollPosition)
            
            if scrollPosition == "вверх" {
                position -= 20
            } else if scrollPosition == "вниз" {
                position += 20
            }
            
            self.WVWEBview.scrollView.setContentOffset(CGPoint(x: 0, y: position), animated: true)
        }
    }
}
