//
//  CalendarMultipleDatesViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 26.06.2024.
//

import UIKit

final class CalendarMultipleDatesViewController: UIViewController {

    let calendarView = UICalendarView()
    
    var selection: UICalendarSelectionMultiDate?

    // MARK: - сервисы
    let viewModel = CalendarMultipleDatesViewModel()
    
    var id: String = ""
    var owner: String = ""
    
    // MARK: - Init
    init(id: String, owner: String) {
        self.id = id
        self.owner = owner
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpNavigation()
        configureCalendar()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .done, target: self, action: #selector(closeScreen))
        let selectDateButton = UIBarButtonItem(title: "Выбрать", style: .done, target: self, action: #selector(selectDates))
        closeButton.tintColor = .label
        selectDateButton.tintColor = .label
        navigationItem.title = "Выберите даты"
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.rightBarButtonItem = selectDateButton
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        self.dismiss(animated: true)
    }
    
    @objc private func selectDates() {
        if let selection = selection {
            viewModel.selectDates(dates: selection)
        } else {
            showAlert(title: "Даты не выбраны!", message: "выберите хотя бы одну дату", actions: [UIAlertAction(title: "ОК", style: .default)])
        }
    }
    
    private func configureCalendar() {
        
        let dateSelection = UICalendarSelectionMultiDate(delegate: self)
        calendarView.selectionBehavior = dateSelection
        calendarView.delegate = self
        
        calendarView.calendar = .current
        calendarView.locale = .current
        
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(calendarView)
        
        NSLayoutConstraint.activate([
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            calendarView.topAnchor.constraint(equalTo: view.topAnchor),
            calendarView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.registerAlertHandler { title, message in
            self.showAlert(title: title, message: message, actions: [UIAlertAction(title: "ОК", style: .default)])
        }
        viewModel.registerDatesSelectedHandler {
            guard let selection = self.selection else {return}
            let vc = TimeTableDatesListViewController(id: self.id, owner: self.owner, dates: self.viewModel.getDates(from: selection))
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
            HapticsManager.shared.hapticFeedback()
        }
    }
}
