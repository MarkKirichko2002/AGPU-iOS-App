//
//  WebViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 11.06.2023.
//

import UIKit
import WebKit

final class WebViewController: UIViewController {

    var url: String
    
    // MARK: - сервисы
    let viewModel = WebViewModel()
    private var timer: Timer?
    
    // MARK: - UI
    let WVWEBview = WKWebView(frame: .zero)
    let spinner = UIActivityIndicatorView(style: .large)
    
    // MARK: - Init
    init(
        url: String
    ) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUpWebView()
        SetUpIndicatorView()
        SetUpNavigation()
        SetUpViewModel()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.viewModel.SaveCurrentPage(url: self.WVWEBview.url?.absoluteString ?? "", position: CGPoint(x: 0, y: self.WVWEBview.scrollView.contentOffset.y))
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.post(name: Notification.Name("screen was closed"), object: nil)
        timer?.invalidate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func SetUpWebView() {
        view.addSubview(WVWEBview)
        view = WVWEBview
        WVWEBview.allowsBackForwardNavigationGestures = true
        WVWEBview.scrollView.delegate = self
        WVWEBview.navigationDelegate = self
        WVWEBview.load(self.url)
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
        let backbutton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        backbutton.tintColor = .black
        let forwardbutton = UIBarButtonItem(image: UIImage(systemName: "chevron.right"), style: .plain, target: self, action: #selector(forwardButtonTapped))
        forwardbutton.tintColor = .black
        let closebutton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeButtonTapped))
        closebutton.tintColor = .black
        self.navigationItem.rightBarButtonItems = [forwardbutton, backbutton]
        self.navigationItem.leftBarButtonItem = closebutton
    }
    
    private func SetUpViewModel() {
        viewModel.ObserveScroll { position in
            self.WVWEBview.scrollView.setContentOffset(position, animated: true)
        }
        viewModel.ObserveActions {
            if self.navigationController?.viewControllers.first == self {
                self.dismiss(animated: true)
            } else {
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
    
    @objc private func closeButtonTapped() {
        self.dismiss(animated: true)
    }
}
