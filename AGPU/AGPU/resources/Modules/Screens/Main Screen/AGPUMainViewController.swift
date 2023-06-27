//
//  AGPUMainViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 27.06.2023.
//

import UIKit
import WebKit

class AGPUMainViewController: UIViewController {

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
        SetUpWebView()
        SetUpNavigation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func SetUpWebView() {
        view.addSubview(WVWEBview)
        view = WVWEBview
        WVWEBview.allowsBackForwardNavigationGestures = true
        let request = URLRequest(url: self.url)
        DispatchQueue.main.async {
            self.WVWEBview.load(request)
        }
    }
    
    private func SetUpNavigation() {
        let backbutton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        backbutton.tintColor = .black
        let forwardbutton = UIBarButtonItem(image: UIImage(systemName: "chevron.right"), style: .plain, target: self, action: #selector(forwardButtonTapped))
        forwardbutton.tintColor = .black
        self.navigationItem.rightBarButtonItems = [forwardbutton, backbutton]
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
}
