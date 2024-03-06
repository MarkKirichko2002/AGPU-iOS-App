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
    private let viewModel = CustomSplashScreenEditorViewModel()
    
    private func setUpNavigation() {
        navigationItem.title = "Экран заставки"
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        let backButton = UIBarButtonItem(customView: button)
        let saveButton = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(saveScreen))
        saveButton.tintColor = .label
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = saveButton
    }
    
    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func saveScreen() {
        let screen = CustomSplashScreenModel()
        screen.image = CustomIcon.image?.jpegData(compressionQuality: 1.0)
        screen.title = CustomTitleLabel.text!
        viewModel.saveCustomSplashScreen(screen: screen)
    }
    
    private func setUpView() {
        view.backgroundColor = .systemBackground
        view.addSubviews(CustomIcon, CustomTitleLabel)
        setUpImageGesture()
        setUpLabelGesture()
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
    
    @objc private func showTitleAlert() {
        let alertVC = UIAlertController(title: "Изменение названия", message: "сохранить изменение?", preferredStyle: .alert)
        alertVC.addTextField { [weak self] textField in
            textField.text = self?.CustomTitleLabel.text!
            textField.placeholder = "введите текст..."
        }
        
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { [weak self] _ in
            let screen = CustomSplashScreenModel()
            screen.id = 1
            screen.title = alertVC.textFields?[0].text ?? ""
            self?.viewModel.saveCustomSplashScreen(screen: screen)
        }
        let cancel = UIAlertAction(title: "Отмена", style: .destructive)
        alertVC.addAction(saveAction)
        alertVC.addAction(cancel)
        present(alertVC, animated: true)
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
        print(UIScreen.main.bounds.width / 4)
    }
    
    private func bindViewModel() {
        viewModel.registerScreenUpdatedHandler { [weak self] screen in
            if let image = screen.image {
                DispatchQueue.main.async {
                    self?.CustomIcon.image = UIImage(data: image)
                }
            } else {}
            self?.CustomTitleLabel.text = screen.title
        }
        viewModel.getCustomSplashScreen()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpView()
        bindViewModel()
    }
}

extension CustomSplashScreenEditorViewController {
    
    @objc func showPhotoAlert() {
        let alertVC = UIAlertController(title: "Выберите фото", message: "Выберите источник для загрузки фото", preferredStyle: .alert)
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
        present(alertVC, animated: true)
    }
}

extension CustomSplashScreenEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        CustomIcon.image = image
        self.dismiss(animated: true)
    }
}
