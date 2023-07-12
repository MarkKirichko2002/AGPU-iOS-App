//
//  AGPUMainViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 27.06.2023.
//

import UIKit
import WebKit

class AGPUMainViewController: UIViewController {

    // MARK: - сервисы
    private let viewModel = AGPUMainViewModel()
    
    // MARK: - UI
    let WVWEBview = WKWebView(frame: .zero)
    let spinner = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        SetUpWebView()
        SetUpIndicatorView()
        SetUpNavigation()
        SetUpViewModel()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func SetUpWebView() {
        view.addSubview(WVWEBview)
        view = WVWEBview
        WVWEBview.allowsBackForwardNavigationGestures = true
        WVWEBview.navigationDelegate = self
        DispatchQueue.main.async {
            self.WVWEBview.load("http://test.agpu.net/")
        }
    }
    
    private func SetUpIndicatorView() {
        view.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func SetUpNavigation() {
        let reloadButton = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .plain, target: self, action: #selector(reloadButtonTapped))
        reloadButton.tintColor = .black
        let backbutton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        backbutton.tintColor = .black
        let forwardbutton = UIBarButtonItem(image: UIImage(systemName: "chevron.right"), style: .plain, target: self, action: #selector(forwardButtonTapped))
        forwardbutton.tintColor = .black
        self.navigationItem.rightBarButtonItems = [forwardbutton, backbutton]
        self.navigationItem.leftBarButtonItem = reloadButton
    }
    
    private func SetUpViewModel() {
        viewModel.GetDate()
        viewModel.registerDateHandler { date in
            self.navigationItem.title = date
        }
        viewModel.ObserveScroll { position in
            self.WVWEBview.scrollView.setContentOffset(position, animated: true)
        }
    }
    
    @objc private func reloadButtonTapped() {
        if let url = WVWEBview.url?.absoluteString {
            DispatchQueue.main.async {
                self.WVWEBview.load(url)
            }
        }
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
