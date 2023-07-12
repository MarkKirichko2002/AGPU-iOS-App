//
//  AGPUNewsViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 27.06.2023.
//

import UIKit
import WebKit

class AGPUNewsViewController: UIViewController {
    
    // MARK: - сервисы
    private let viewModel = AGPUNewsViewModel()
    
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
            self.WVWEBview.load(self.viewModel.faculty?.newsURL ?? "http://test.agpu.net/news.php")
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
        self.navigationItem.title = viewModel.faculty == nil ? "Новости «АГПУ»" : "Новости \(viewModel.faculty?.abbreviation ?? "")"
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
        viewModel.registerScrollHandler { position in
            self.WVWEBview.scrollView.setContentOffset(position, animated: true)
        }
        viewModel.registerFacultyHandler { faculty in
            DispatchQueue.main.async {
                self.navigationItem.title = "Новости \(faculty.abbreviation)"
                self.WVWEBview.load(faculty.newsURL)
            }
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
