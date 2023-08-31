//
//  WordDocumentReaderViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 13.08.2023.
//

import UIKit
import WebKit

final class WordDocumentReaderViewController: UIViewController {

    var url: String
    
    // MARK: - сервисы
    let viewModel = WordDocumenReaderViewModel()
    
    // MARK: - UI
    let WVWEBview = WKWebView(frame: .zero)
    let spinner = UIActivityIndicatorView(style: .large)
    
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
        setUpNavigation()
        setUpWebView()
        setUpIndicatorView()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        let titleView = CustomTitleView(image: "word", title: "Word-документ", frame: .zero)
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .done, target: self, action: #selector(close))
        closeButton.tintColor = .black
        let sections = UIBarButtonItem(image: UIImage(named: "sections"), menu: makeMenu())
        sections.tintColor = .black
        
        navigationItem.titleView = titleView
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.rightBarButtonItem = sections
    }
    
    @objc private func close() {
        self.dismiss(animated: true)
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
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func makeMenu()-> UIMenu {
        let shareAction = UIAction(title: "поделиться", image: UIImage(named: "share")) { _ in
            self.shareInfo(image: UIImage(named: "word")!, title: "Word-документ", text: self.url)
        }
        let menu = UIMenu(title: "Word-документ", children: [shareAction])
        return menu
    }
    
    private func bindViewModel() {
        viewModel.observeScroll { position in
            self.WVWEBview.scrollView.setContentOffset(position, animated: true)
        }
        viewModel.observeActions {
            if self.navigationController?.viewControllers.first == self {
                self.dismiss(animated: true)
            } else {}
        }
    }
}
