//
//  CalendarMultipleDatesViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 26.06.2024.
//

import UIKit

protocol CalendarMultipleDatesViewControllerDelegate: AnyObject {
    func datesWasSelected(dates: [String])
}

final class CalendarMultipleDatesViewController: UIViewController {

    let calendarView = UICalendarView()
    
    var selection: UICalendarSelectionMultiDate?
    weak var delegate: CalendarMultipleDatesViewControllerDelegate?
    
    var isForList = false

    // MARK: - сервисы
    let viewModel = CalendarMultipleDatesViewModel()
    
    var id: String = ""
    var date: String = ""
    var subgroup: Int = 0
    var owner: String = ""
    
    // MARK: - Init
    init(id: String, date: String, subgroup: Int, owner: String) {
        self.id = id
        self.date = date
        self.subgroup = subgroup
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
        navigationItem.title = viewModel.titleForNavigation()
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
            showAlert(title: viewModel.createAlertMessage().0, message: viewModel.createAlertMessage().1, actions: [UIAlertAction(title: "ОК", style: .default)])
        }
    }
    
    private func configureCalendar() {
        
        let dateSelection = UICalendarSelectionMultiDate(delegate: self)
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
    
    private func bindViewModel() {
        viewModel.registerAlertHandler { title, message in
            self.showAlert(title: title, message: message, actions: [UIAlertAction(title: "ОК", style: .default)])
        }
        viewModel.registerDatesSelectedHandler {
            self.handleSelection()
        }
    }
    
    func handleSelection() {
        guard let selection = self.selection else {return}
        if isForList {
            delegate?.datesWasSelected(dates: viewModel.getDates(from: selection))
            dismiss(animated: true)
        } else {
            let vc = TimeTableDatesListViewController(id: self.id, subgroup: self.subgroup, owner: self.owner, dates: self.viewModel.getDates(from: selection))
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        HapticsManager.shared.hapticFeedback()
    }
}
