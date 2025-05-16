//
//  SimpleCalendarViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 01.10.2024.
//

import UIKit

protocol SimpleCalendarViewControllerDelegate: AnyObject {
    func dateFromCalendarWasSelected(date: String)
}

final class SimpleCalendarViewController: UIViewController {

    // MARK: - сервисы
    let viewModel = CalendarViewModel()
    
    var date: String = ""
    
    var selection: UICalendarSelectionSingleDate?
    
    weak var delegate: SimpleCalendarViewControllerDelegate?
    
    var isSection = false
    
    let calendarView = UICalendarView()
    
    // MARK: - Init
    init(date: String) {
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
        configureCalendar()
    }
    
    private func setUpNavigation() {
        navigationItem.title = "Календарь"
        setUpBackButton()
    }
    
    func setUpBackButton() {
        
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        let backButton = UIBarButtonItem(customView: button)
        
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
        
    private func configureCalendar() {
        
        let dateSelection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = dateSelection
        calendarView.delegate = self
        
        calendarView.calendar = .current
        calendarView.locale = .current
        
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.tintColor = .label
        calendarView.setVisibleDateComponents(viewModel.makeDateComponents(date: date), animated: true)
        view.addSubview(calendarView)
        
        NSLayoutConstraint.activate([
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            calendarView.topAnchor.constraint(equalTo: view.topAnchor),
            calendarView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UICalendarSelectionSingleDateDelegate
extension SimpleCalendarViewController: UICalendarSelectionSingleDateDelegate {
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        let date = viewModel.getFormattedDate(date: selection.selectedDate?.date ?? Date())
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            self.delegate?.dateFromCalendarWasSelected(date: date)
            self.back()
        }
        HapticsManager.shared.hapticFeedback()
    }
}

// MARK: - UICalendarViewDelegate
extension SimpleCalendarViewController: UICalendarViewDelegate {
    
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        return .default(color: viewModel.compareDates(date1: self.date, date2: dateComponents.date ?? Date()))
    }
}
