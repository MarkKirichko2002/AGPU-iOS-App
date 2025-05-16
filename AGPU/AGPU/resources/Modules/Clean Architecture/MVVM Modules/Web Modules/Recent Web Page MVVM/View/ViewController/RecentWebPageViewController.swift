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
        setUpFloatingButton()
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
    
    private func setUpFloatingButton() {
        let navigationButton = UIButton()
        navigationButton.showsMenuAsPrimaryAction = true
        navigationButton.tintColor = .label
        navigationButton.setImage(UIImage(named: "aspu logo"), for: .normal)
        navigationButton.accessibilityIdentifier = "floating button"
        navigationButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationButton)
        NSLayoutConstraint.activate([
            navigationButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40.0),
            navigationButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30.0),
            navigationButton.widthAnchor.constraint(equalToConstant: 70.0),
            navigationButton.heightAnchor.constraint(equalToConstant: 70.0)
        ])
        navigationButton.menu = setUpMenu()
    }
    
    private func setUpMenu()-> UIMenu {
        let positions = scrollMenu()
        let saveAction = UIAction(title: "Сохранить") { _ in
            self.viewModel.saveWebPage(url: self.page.url)
        }
        return UIMenu(title: "Web-страница", children: [saveAction, positions])
    }
    
    private func scrollMenu()-> UIMenu {
        let actions = scrollPositions.allCases.map { position in UIAction(title: position.rawValue, state: viewModel.currentScrollPosition == position ? .on: .off) { _  in
            self.viewModel.currentScrollPosition = position
            switch position {
            case .top:
                self.WVWEBview.scrollToUp()
                self.updateMenuButton()
            case .middle:
                self.WVWEBview.scrollToMiddle()
                self.updateMenuButton()
            case .end:
                self.WVWEBview.scrollToDown()
                self.updateMenuButton()
            }
        }
        }
        return UIMenu(title: "Позиции", children: actions.reversed())
    }
    
    private func updateMenuButton() {
        guard let button = view.subviews.first(where: { $0.accessibilityIdentifier == "floating button" }) else {return}
        (button as? UIButton)?.menu = setUpMenu()
    }
}
