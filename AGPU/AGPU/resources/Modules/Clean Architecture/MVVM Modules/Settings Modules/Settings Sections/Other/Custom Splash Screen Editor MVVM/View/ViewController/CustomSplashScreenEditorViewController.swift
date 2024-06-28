//
//  CustomSplashScreenEditorViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 28.02.2024.
//

import UIKit

class CustomSplashScreenEditorViewController: UIViewController {

    // MARK: - UI
    // иконка
    let CustomIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "АГПУ")
        icon.clipsToBounds = true
        icon.isUserInteractionEnabled = true
        icon.contentMode = .scaleAspectFill
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    // название
    let CustomTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Ваш текст"
        label.isUserInteractionEnabled = true
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - сервисы
    let viewModel = CustomSplashScreenEditorViewModel()
    
    private func setUpNavigation() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationItem.title = "Экран заставки"
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        let backButton = UIBarButtonItem(customView: button)
        let sections = UIBarButtonItem(image: UIImage(named: "sections"), menu: setUpMenu())
        sections.tintColor = .label
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = sections
    }
    
    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
    
    private func reset() {
        CustomIcon.image = UIImage(named: "АГПУ")
        CustomTitleLabel.textColor = .label
        CustomTitleLabel.text = "Ваш текст"
        viewModel.colorOption = .system
        view.backgroundColor = .systemBackground
        HapticsManager.shared.hapticFeedback()
    }
    
    @objc private func saveScreen() {
        let screen = CustomSplashScreenModel()
        screen.id = 1
        screen.image = CustomIcon.image?.jpegData(compressionQuality: 1.0)
        screen.title = CustomTitleLabel.text!
        screen.color = viewModel.colorOption.title
        viewModel.saveCustomSplashScreen(screen: screen)
        HapticsManager.shared.hapticFeedback()
    }
    
    private func setUpView() {
        view.backgroundColor = .systemBackground
        view.addSubviews(CustomIcon, CustomTitleLabel)
        setUpViewGesture()
        setUpConstraints()
    }
    
    private func setUpImageGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(showPhotoAlert))
        CustomIcon.addGestureRecognizer(tap)
    }
        
    private func setUpLabelGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(showTitleAlert))
        CustomTitleLabel.addGestureRecognizer(tap)
    }
    
    private func setUpViewGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(showColorsListVC))
        view.addGestureRecognizer(tap)
    }
    
    private func setUpMenu()-> UIMenu {
        
        let photoAction = UIAction(title: "Фото") { _ in
            self.showPhotoAlert()
        }
        
        let titleAction = UIAction(title: "Надпись") { _ in
            self.showTitleAlert()
        }
        
        let colorAction = UIAction(title: "Цвет фона") { _ in
            self.showColorsListVC()
        }
        
        let resetAction = UIAction(title: "Сбросить") { _ in
            self.reset()
        }
        
        let saveAction = UIAction(title: "Сохранить") { _ in
            self.saveScreen()
        }
        
        return UIMenu(title: "Экран заставки", children: [
            photoAction,
            titleAction,
            colorAction,
            resetAction,
            saveAction
        ])
    }
    
    @objc func showPhotoAlert() {
        let alertVC = UIAlertController(title: "Выберите источник", message: "Выберите источник для загрузки фото", preferredStyle: .alert)
        let vc = UIImagePickerController()
        let photo = UIAlertAction(title: "Галерея", style: .default) { _ in
            vc.delegate = self
            vc.sourceType = .photoLibrary
            vc.allowsEditing = true
            self.present(vc, animated: true)
        }
        let camera = UIAlertAction(title: "Камера", style: .default) { _ in
            vc.delegate = self
            vc.sourceType = .camera
            vc.allowsEditing = true
            self.present(vc, animated: true)
        }
        let cancel = UIAlertAction(title: "Отмена", style: .destructive)
        
        alertVC.addAction(photo)
        alertVC.addAction(camera)
        alertVC.addAction(cancel)
        HapticsManager.shared.hapticFeedback()
        present(alertVC, animated: true)
    }
    
    @objc private func showTitleAlert() {
        let alertVC = UIAlertController(title: "Изменение названия", message: "Хотите изменить название?", preferredStyle: .alert)
        alertVC.addTextField { [weak self] textField in
            textField.text = self?.CustomTitleLabel.text!
            textField.placeholder = "введите текст..."
        }
        let changeAction = UIAlertAction(title: "Изменить", style: .default) { [weak self] _ in
            self?.CustomTitleLabel.text = alertVC.textFields?[0].text ?? ""
        }
        let cancel = UIAlertAction(title: "Отмена", style: .destructive)
        alertVC.addAction(changeAction)
        alertVC.addAction(cancel)
        HapticsManager.shared.hapticFeedback()
        present(alertVC, animated: true)
    }
    
    @objc private func showColorsListVC() {
        let vc = SplashScreenBackgroundColorsListTableViewController(colorOption: viewModel.colorOption)
        vc.delegate = self
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        HapticsManager.shared.hapticFeedback()
        present(navVC, animated: true)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            // иконка
            CustomIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            CustomIcon.widthAnchor.constraint(equalToConstant: 180),
            CustomIcon.heightAnchor.constraint(equalToConstant: 180),
            // название
            CustomTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            CustomTitleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            CustomTitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            CustomTitleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            CustomTitleLabel.heightAnchor.constraint(equalToConstant: 100),
            CustomTitleLabel.topAnchor.constraint(equalTo: CustomIcon.bottomAnchor, constant: 50)
        ])
    }
    
    private func bindViewModel() {
        viewModel.registerScreenUpdatedHandler { [weak self] screen in
            let color = BackgroundColors.allCases.first { $0.title == screen.color }
            if let image = screen.image {
                DispatchQueue.main.async {
                    self?.CustomIcon.image = UIImage(data: image)
                }
            } else {}
            if color != .system {
                self?.CustomTitleLabel.textColor = color == nil ? .label : .white
            } else {
                self?.CustomTitleLabel.textColor = .label
            }
            self?.CustomTitleLabel.text = screen.title
            self?.view.backgroundColor = color?.color ?? .systemBackground
        }
        viewModel.getCustomSplashScreen()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpView()
        bindViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUpImageGesture()
        setUpLabelGesture()
    }
}
