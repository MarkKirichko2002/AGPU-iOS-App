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
    weak var delegate: ScreenClosedDelegate?
    
    // MARK: - сервисы
    let viewModel = WebViewModel()
    let animation = AnimationClass()
    
    // MARK: - UI
    let WVWEBview = WKWebView(frame: .zero)
    
    let spinner: SpringImageView = {
        let imageView = SpringImageView()
        imageView.image = UIImage(named: "АГПУ")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
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
        setUpFloatingButton()
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
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
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
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            spinner.widthAnchor.constraint(equalToConstant: 75),
            spinner.heightAnchor.constraint(equalToConstant: 75),
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
                }
            case .forward:
                DispatchQueue.main.async {
                    self.WVWEBview.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                }
                self.forwardButtonTapped()
            case .back:
                DispatchQueue.main.async {
                    self.WVWEBview.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                }
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
        if isNotify {
            delegate?.screenWasClosed()
        } else {
            HapticsManager.shared.hapticFeedback()
        }
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
            self.viewModel.saveWebPage(url: self.url)
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
