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
    var isNotify: Bool
    
    // MARK: - сервисы
    let viewModel = WebViewModel()
    
    // MARK: - UI
    let WVWEBview = WKWebView(frame: .zero)
    let spinner = UIActivityIndicatorView(style: .large)
    var titleView: CustomTitleView!
    
    // MARK: - Init
    init(url: String, isNotify: Bool) {
        self.url = url
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
        setUpIndicatorView()
        bindViewModel()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setUpNavigation() {
        let backButton = UIBarButtonItem(image: UIImage(named: "left"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .label
        let forwardbutton = UIBarButtonItem(image: UIImage(named: "right"), style: .plain, target: self, action: #selector(forwardButtonTapped))
        forwardbutton.tintColor = .label
        let closebutton = UIBarButtonItem(image: UIImage(named: "cross"), style: .plain, target: self, action: #selector(closeScreen))
        closebutton.tintColor = .label
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
    
    private func setUpIndicatorView() {
        view.addSubview(spinner)
        spinner.color = UIColor.black
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.observeScroll { position in
            DispatchQueue.main.async {
                self.WVWEBview.scrollView.setContentOffset(position, animated: true)
            }
        }
        
        viewModel.observeActions { action in
            switch action {
            case .closeScreen:
                if self.navigationController?.viewControllers.first == self {
                    self.dismiss(animated: true)
                } else {}
            case .forward:
                self.forwardButtonTapped()
            case .back:
                self.backButtonTapped()
            }
        }
        
        viewModel.observeSectionSelected { section in
            self.titleView = CustomTitleView(image: section.icon, title: section.name, frame: .zero)
            DispatchQueue.main.async {
                self.navigationItem.titleView = self.titleView
            }
            self.WVWEBview.load(section.url)
        }
        
        viewModel.observeSubSectionSelected { subsection in
            self.titleView = CustomTitleView(image: "АГПУ", title: "АГПУ сайт", frame: .zero)
            DispatchQueue.main.async {
                self.navigationItem.titleView = self.titleView
            }
            self.WVWEBview.load(subsection.url)
        }
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
