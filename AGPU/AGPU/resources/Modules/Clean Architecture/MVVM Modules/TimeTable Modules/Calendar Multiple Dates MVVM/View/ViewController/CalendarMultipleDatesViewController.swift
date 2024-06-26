//
//  CalendarMultipleDatesViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 26.06.2024.
//

import UIKit

protocol CalendarMultipleDatesViewControllerDelegate: AnyObject {
    func datesWereSelected()
}

final class CalendarMultipleDatesViewController: UIViewController {

    let calendarView = UICalendarView()
    
    var selection: UICalendarSelectionMultiDate?
    
    weak var delegate: CalendarMultipleDatesViewControllerDelegate?
    
    // MARK: - сервисы
    private let viewModel = CalendarMultipleDatesViewModel()
    
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
        guard let selection = selection else {return}
        viewModel.selectDates(dates: selection)
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
        viewModel.registerAlertHandler {
            self.showAlert(title: "Выбрано много дат!", message: "вы выбрали \(self.selection?.selectedDates.count ?? 0) дат выберите не больше 7", actions: [UIAlertAction(title: "ОК", style: .default)])
        }
        viewModel.registerDatesSelectedHandler {
            self.delegate?.datesWereSelected()
            self.dismiss(animated: true)
        }
    }
}
