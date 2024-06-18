//
//  WordRecentDocumentViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 13.08.2023.
//

import UIKit
import WebKit

class WordRecentDocumentViewController: UIViewController {
    
    var document: RecentWordDocumentModel
    
    // MARK: - сервисы
    let viewModel = WordRecentDocumentViewModel()
    let animation = AnimationClass()
    
    // MARK: - UI
    let WVWEBview = WKWebView(frame: .zero)
    
    let spinner: SpringImageView = {
        let imageView = SpringImageView()
        imageView.image = UIImage(named: "word")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Init
    init(document: RecentWordDocumentModel) {
        self.document = document
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
    
    private func setUpNavigation() {
        let titleView = CustomTitleView(image: "word", title: "\(document.date) \(document.time)", frame: .zero)
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
        WVWEBview.navigationDelegate = self
        WVWEBview.load(self.document.url)
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
            spinner.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
    
    private func makeMenu()-> UIMenu {
        let shareAction = UIAction(title: "Поделиться", image: UIImage(named: "share")) { _ in
            self.shareInfo(image: UIImage(named: "word")!, title: "Word-документ", text: self.document.url)
        }
        let menu = UIMenu(title: "Word-документ", children: [shareAction])
        return menu
    }
}
