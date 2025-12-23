//
//  AIInfoViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 19.12.2025.
//

import UIKit

final class AIInfoViewController: UIViewController {
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isHidden = true
        textView.font = .systemFont(ofSize: 17, weight: .bold)
        textView.textColor = .label
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let spinner = UIActivityIndicatorView(style: .large)
    
    private var viewModel: AIInfoViewModel
    
    init(text: String) {
        self.viewModel = AIInfoViewModel(text: text)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpNavigation()
        setUpIndicatorView()
        setUpTextView()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        let titleView = CustomTitleView(image: "info", title: "ИИ информация", frame: .zero)
        navigationItem.titleView = titleView
        setUpCloseButton()
        setUpMenuButton()
    }
    
    private func setUpMenuButton() {
        let menu = UIBarButtonItem(image: UIImage(named: "sections"), menu: setUpMenu())
        menu.accessibilityIdentifier = "menu"
        menu.tintColor = .label
        navigationItem.rightBarButtonItem = menu
    }
    
    private func setUpCloseButton() {
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .done, target: self, action: #selector(close))
        closeButton.tintColor = .label
        navigationItem.leftBarButtonItem = closeButton
    }
    
    @objc private func close() {
        HapticsManager.shared.hapticFeedback()
        dismiss(animated: true)
    }
    
    private func setUpMenu()-> UIMenu {
        let restart = UIAction(title: "Повторить") { _ in
            self.restartResponse()
        }
        let copy = UIAction(title: "Скопировать") { _ in
            UIPasteboard.general.string = self.textView.text
            self.showAlert(title: "Текст скопирован!", message: "", actions: [UIAlertAction(title: "ОК", style: .default)])
        }
        return UIMenu(title: "AI информация", children: [restart, makeModelsListMenu(), copy])
    }
    
    private func restartResponse() {
        self.spinner.startAnimating()
        self.textView.isHidden = true
        self.viewModel.getInfo()
    }
    
    private func makeModelsListMenu()-> UIMenu {
        var items = [UIAction]()
        let models = viewModel.getGeminiModels()
        models.forEach { model in
            let state: UIMenuElement.State = (model == viewModel.getCurrentGeminiModel()) ? .on : .off
            let action = UIAction(title: model, state: state) { _ in
                self.viewModel.selectGeminiModel(model: model)
                self.restartResponse()
            }
            items.append(action)
        }
        
        return UIMenu(title: "Модели Gemini", children: items)
    }
    
    func updateMenu() {
        guard let item = self.navigationItem.rightBarButtonItems?.first(where: { $0.accessibilityIdentifier == "menu" }) else {return}
        item.menu = setUpMenu()
    }
    
    private func setUpIndicatorView() {
        view.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        spinner.startAnimating()
    }
    
    private func setUpTextView() {
        view.addSubview(textView)
        textView.layer.borderWidth = 2
        textView.layer.cornerRadius = 5
        textView.layer.borderColor = UIColor.label.cgColor
        textView.textAlignment = .left
        NSLayoutConstraint.activate([
            textView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            textView.widthAnchor.constraint(equalToConstant: view.frame.width),
            textView.heightAnchor.constraint(equalToConstant: view.frame.height),
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            textView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            textView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
        ])
    }
    
    private func bindViewModel() {
        viewModel.registerAIInfoHandler { text in
            DispatchQueue.main.async {
                self.textView.text = text
                self.textView.isHidden = false
                self.spinner.stopAnimating()
            }
        }
        viewModel.registerModelsMenuChangedHandler {
            DispatchQueue.main.async {
                self.updateMenu()
            }
        }
        viewModel.getInfo()
    }
}
