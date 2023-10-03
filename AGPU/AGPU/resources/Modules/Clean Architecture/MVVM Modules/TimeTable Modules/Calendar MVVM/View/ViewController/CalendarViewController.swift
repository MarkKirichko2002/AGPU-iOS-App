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
    
    // MARK: - UI
    private let Calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.appearance.titleDefaultColor = .label
        calendar.backgroundColor = .systemBackground
        calendar.translatesAutoresizingMaskIntoConstraints = false
        return calendar
    }()
    
    // MARK: - Init
    init(group: String) {
        self.viewModel = CalendarViewModel(group: group)
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
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .done, target: self, action: #selector(close))
        closeButton.tintColor = .label
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func close() {
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
        viewModel.registerDateSelectedHandler {
            self.dismiss(animated: true)
        }
        // алерты
        // есть пары
        viewModel.registerTimetableAlertHandler { message in
            let choose = UIAlertAction(title: "выбрать", style: .default) { _ in
                self.viewModel.sendNotificationDataWasSelected(date: self.viewModel.date)
                self.dismiss(animated: true)
            }
            let cancel = UIAlertAction(title: "отмена", style: .default) { _ in}
            self.showAlert(title: "У группы \(self.viewModel.group) есть расписание", message: message, actions: [choose, cancel])
        }
        // нет пар
        viewModel.registerNoTimetableAlertHandler { message in
            let choose = UIAlertAction(title: "выбрать", style: .default) { _ in
                self.viewModel.sendNotificationDataWasSelected(date: self.viewModel.date)
                self.dismiss(animated: true)
            }
            let cancel = UIAlertAction(title: "отмена", style: .default) { _ in}
            self.showAlert(title: "У группы \(self.viewModel.group) нет расписания", message: message, actions: [choose, cancel])
        }
    }
}
