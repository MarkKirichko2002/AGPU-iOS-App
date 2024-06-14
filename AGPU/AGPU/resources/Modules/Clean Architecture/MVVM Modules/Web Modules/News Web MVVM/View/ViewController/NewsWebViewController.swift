//
//  NewsWebViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 06.03.2024.
//

import UIKit
import WebKit

final class NewsWebViewController: UIViewController {

    var url: String
    var isNotify: Bool
    
    // MARK: - сервисы
    let viewModel: NewsWebViewModel
    let animation = AnimationClass()
    
    // MARK: - UI
    let WVWEBview = WKWebView(frame: .zero)
    let spinner: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "АГПУ")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    var titleView: CustomTitleView!
    
    // MARK: - Init
    init(article: Article, url: String, isNotify: Bool) {
        self.url = url
        self.viewModel = NewsWebViewModel(article: article, url: url)
        self.isNotify = isNotify
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
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
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
        spinner.image = UIImage(named: viewModel.getCategoryIcon(url: url))
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            spinner.widthAnchor.constraint(equalToConstant: 75),
            spinner.heightAnchor.constraint(equalToConstant: 75)
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
        if isNotify {
            sendScreenWasClosedNotification()
        }
        self.dismiss(animated: true)
    }
}
