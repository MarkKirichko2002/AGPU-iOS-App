//
//  RecentSectionViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 06.07.2023.
//

import UIKit
import WebKit

class RecentSectionViewController: UIViewController {
    
    var url: String
    
    // MARK: - UI
    let WVWEBview = WKWebView(frame: .zero)
    
    // MARK: - Init
    init(url: String) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUpWebView()
        SetUpNavigation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.post(name: Notification.Name("WebScreenWasClosed"), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func SetUpWebView() {
        view.addSubview(WVWEBview)
        view = WVWEBview
        WVWEBview.allowsBackForwardNavigationGestures = true
        WVWEBview.navigationDelegate = self
        WVWEBview.load(self.url)
    }
    
    private func SetUpNavigation() {
        let backbutton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        backbutton.tintColor = .black
        let forwardbutton = UIBarButtonItem(image: UIImage(systemName: "chevron.right"), style: .plain, target: self, action: #selector(forwardButtonTapped))
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
}
