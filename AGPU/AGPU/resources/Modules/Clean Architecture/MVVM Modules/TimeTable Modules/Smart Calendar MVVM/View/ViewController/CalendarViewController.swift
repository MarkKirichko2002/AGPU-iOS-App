//
//  CalendarViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 12.07.2023.
//

import UIKit
import FSCalendar

final class CalendarViewController: UIViewController {

    // MARK: - сервисы
    let viewModel: CalendarViewModel
    
    var id: String = ""
    var date: String = ""
    var owner: String = ""
    
    // MARK: - UI
    private let Calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.appearance.titleDefaultColor = .label
        calendar.backgroundColor = .systemBackground
        calendar.translatesAutoresizingMaskIntoConstraints = false
        return calendar
    }()
    
    // MARK: - Init
    init(id: String, date: String, owner: String) {
        self.viewModel = CalendarViewModel(id: id, owner: owner)
        self.date = date
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpNavigation()
        setUpCalendar()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        navigationItem.title = "Календарь"
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .done, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .label
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        self.dismiss(animated: true)
    }
    
    private func setUpCalendar() {
        view.addSubview(Calendar)
        Calendar.delegate = self
        makeConstraints()
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            Calendar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            Calendar.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            Calendar.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            Calendar.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    private func bindViewModel() {
        // алерты
        viewModel.registerTimetableAlertHandler { title, message, color in
            
            let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let customTitle = NSAttributedString(string: title, attributes: [
                NSAttributedString.Key.foregroundColor: color
            ])
            
            let choose = UIAlertAction(title: "Выбрать", style: .default) { _ in
                self.viewModel.sendNotificationDataWasSelected(date: self.viewModel.date)
                self.dismiss(animated: true)
            }
            let cancel = UIAlertAction(title: "Отмена", style: .destructive) { _ in}
            
            alertVC.setValue(customTitle, forKey: "attributedTitle")
            alertVC.addAction(choose)
            alertVC.addAction(cancel)
            self.present(alertVC, animated: true)
        }
        // дата выбрана
        viewModel.registerDateSelectedHandler {
            self.dismiss(animated: true)
        }
    }
}
