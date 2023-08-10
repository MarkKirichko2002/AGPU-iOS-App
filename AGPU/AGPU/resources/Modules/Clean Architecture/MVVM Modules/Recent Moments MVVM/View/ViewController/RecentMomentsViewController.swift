//
//  RecentMomentsViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 07.08.2023.
//

import UIKit

class RecentMomentsViewController: UIViewController {
    
    // MARK: - UI
    var stackView: UIStackView!
    
    // MARK: - сервисы
    private let viewModel = RecentMomentsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        SetUpNavigation()
        SetUpStackView()
    }
    
    private func SetUpNavigation() {
        navigationItem.title = "Недавние моменты"
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .black
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func closeScreen() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            NotificationCenter.default.post(name: Notification.Name("screen was closed"), object: nil)
        }
        dismiss(animated: true)
    }
    
    private func SetUpStackView() {
        // Создаем Stack View и задаем свойства
        stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 35
        
        // Создаем кнопки
        let button1 = UIButton()
        button1.setImage(UIImage(named: "online"), for: .normal)
        button1.setTitle(" Веб-страница", for: .normal)
        button1.setTitleColor(.black, for: .normal)
        button1.addTarget(self, action: #selector(CheckLastWebPage), for: .touchUpInside)
        
        let button2 = UIButton()
        button2.setImage(UIImage(named: "document"), for: .normal)
        button2.setTitle(" Документ", for: .normal)
        button2.setTitleColor(.black, for: .normal)
        button2.addTarget(self, action: #selector(CheckLastPDFDocument), for: .touchUpInside)
        
        let button3 = UIButton()
        button3.setImage(UIImage(named: "play icon"), for: .normal)
        button3.setTitle(" Видео", for: .normal)
        button3.setTitleColor(.black, for: .normal)
        button3.addTarget(self, action: #selector(CheckLastVideo), for: .touchUpInside)
        
        // Добавляем кнопки в Stack View
        stackView.addArrangedSubview(button1)
        stackView.addArrangedSubview(button2)
        stackView.addArrangedSubview(button3)
        
        // Добавляем Stack View на ViewController
        view.addSubview(stackView)
        
        // Настраиваем ограничения для Stack View
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func CheckLastWebPage() {
        viewModel.GetLastWebPage { page in
            self.ShowRecentPageScreen(page: page)
        }
    }
    
    @objc private func CheckLastPDFDocument() {
        viewModel.GetLastPDFDocument { pdf in
            let vc = PDFLastPageViewController(pdf: pdf)
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                self.present(navVC, animated: true)
            }
        }
    }
    
    @objc private func CheckLastVideo() {
        viewModel.GetLastVideo { videoURL in
            self.PlayVideo(url: videoURL)
        }
    }
}
