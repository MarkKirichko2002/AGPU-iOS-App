//
//  NewsWebViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 06.03.2024.
//

import UIKit
import WebKit

final class NewsWebViewController: UIViewController {

    // MARK: - сервисы
    let viewModel: NewsWebViewModel
    
    // MARK: - UI
    let WVWEBview = WKWebView(frame: .zero)
    let spinner = UIActivityIndicatorView(style: .large)
    var titleView: CustomTitleView!
    
    var url: String
    
    // MARK: - Init
    init(article: Article, url: String) {
        self.url = url
        self.viewModel = NewsWebViewModel(article: article, url: url)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpWebView()
        setUpScroll()
        setUpIndicatorView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setUpNavigation() {
        let titleView = CustomTitleView(image: "online", title: "Новости", frame: .zero)
        let backButton = UIBarButtonItem(image: UIImage(named: "left"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .label
        let forwardbutton = UIBarButtonItem(image: UIImage(named: "right"), style: .plain, target: self, action: #selector(forwardButtonTapped))
        forwardbutton.tintColor = .label
        let closebutton = UIBarButtonItem(image: UIImage(named: "cross"), style: .plain, target: self, action: #selector(closeScreen))
        closebutton.tintColor = .label
        self.navigationItem.titleView = titleView
        self.navigationItem.rightBarButtonItems = [forwardbutton, backButton]
        self.navigationItem.leftBarButtonItem = closebutton
    }
    
    private func setUpWebView() {
        view.addSubview(WVWEBview)
        view = WVWEBview
        WVWEBview.allowsBackForwardNavigationGestures = true
        WVWEBview.scrollView.delegate = self
        WVWEBview.navigationDelegate = self
        WVWEBview.load(self.url)
    }
    
    private func setUpScroll() {
        WVWEBview.scrollView.delegate = self
        WVWEBview.scrollView.isUserInteractionEnabled = false
    }
    
    private func setUpIndicatorView() {
        view.addSubview(spinner)
        spinner.color = UIColor.black
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func backButtonTapped() {
        if WVWEBview.canGoBack {
            HapticsManager.shared.hapticFeedback()
            WVWEBview.goBack()
        }
    }
    
    @objc private func forwardButtonTapped() {
        if WVWEBview.canGoForward {
            HapticsManager.shared.hapticFeedback()
            WVWEBview.goForward()
        }
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        sendScreenWasClosedNotification()
        self.dismiss(animated: true)
    }
}
