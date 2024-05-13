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
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .done, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .label
        let sections = UIBarButtonItem(image: UIImage(named: "sections"), menu: makeMenu())
        sections.tintColor = .label
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationItem.titleView = titleView
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.rightBarButtonItem = sections
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
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
        spinner.color = UIColor.black
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func makeMenu()-> UIMenu {
        let shareAction = UIAction(title: "Поделиться", image: UIImage(named: "share")) { _ in
            self.shareInfo(image: UIImage(named: "word")!, title: "Word-документ", text: self.url)
        }
        let saveAction = UIAction(title: "Сохранить", image: UIImage(named: "download")) { _ in
            let document = DocumentModel()
            document.name = URL(string: self.url)?.lastPathComponent ?? ""
            document.format = URL(string: self.url)?.pathExtension ?? ""
            document.url = self.url
            self.viewModel.saveCurrentDocument(document: document)
        }
        let menu = UIMenu(title: "Word-документ", children: [shareAction, saveAction])
        return menu
    }
    
    private func bindViewModel() {
        viewModel.observeScroll { position in
            DispatchQueue.main.async {
                self.WVWEBview.scrollView.setContentOffset(position, animated: true)
            }
        }
        viewModel.observeActions {
            if self.navigationController?.viewControllers.first == self {
                self.dismiss(animated: true)
            } else {}
        }
    }
}
