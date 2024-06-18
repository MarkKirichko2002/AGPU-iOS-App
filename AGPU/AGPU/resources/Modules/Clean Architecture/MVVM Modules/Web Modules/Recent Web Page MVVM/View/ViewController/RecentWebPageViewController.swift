//
//  RecentWebPageViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 06.07.2023.
//

import UIKit
import WebKit

final class RecentWebPageViewController: UIViewController {
    
    var page: RecentWebPageModel
    
    // MARK: - сервисы
    let viewModel = RecentWebPageViewModel()
    let animation = AnimationClass()
    
    // MARK: - UI
    let WVWEBview = WKWebView(frame: .zero)
    
    let spinner: SpringImageView = {
        let imageView = SpringImageView()
        imageView.image = UIImage(named: "АГПУ")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Init
    init(page: RecentWebPageModel) {
        self.page = page
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
    
    private func setUpWebView() {
        view.addSubview(WVWEBview)
        view = WVWEBview
        WVWEBview.allowsBackForwardNavigationGestures = true
        WVWEBview.navigationDelegate = self
        WVWEBview.load(self.page.url)
    }
    
    private func setUpScroll() {
        WVWEBview.scrollView.delegate = self
        WVWEBview.scrollView.isUserInteractionEnabled = false
    }
    
    private func setUpIndicatorView() {
        view.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            spinner.widthAnchor.constraint(equalToConstant: 75),
            spinner.heightAnchor.constraint(equalToConstant: 75),
        ])
    }
    
    private func setUpNavigation() {
        let titleView = CustomTitleView(image: "online", title: "\(page.date) \(page.time)", frame: .zero)
        let backbutton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        backbutton.tintColor = .label
        let forwardbutton = UIBarButtonItem(image: UIImage(systemName: "chevron.right"), style: .plain, target: self, action: #selector(forwardButtonTapped))
        forwardbutton.tintColor = .label
        let closebutton = UIBarButtonItem(image: UIImage(named: "cross"), style: .plain, target: self, action: #selector(closeScreen))
        closebutton.tintColor = .label
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        self.navigationItem.titleView = titleView
        self.navigationItem.rightBarButtonItems = [forwardbutton, backbutton]
        self.navigationItem.leftBarButtonItem = closebutton
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
        self.dismiss(animated: true)
    }
}
