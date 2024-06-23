//
//  CalendarViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 12.07.2023.
//

import UIKit

protocol CalendarViewControllerDelegate: AnyObject {
    func dateWasSelected(model: TimeTableChangesModel)
}

final class CalendarViewController: UIViewController {

    // MARK: - сервисы
    let viewModel = CalendarViewModel()
    
    var id: String = ""
    var date: String = ""
    var owner: String = ""
    
    weak var delegate: CalendarViewControllerDelegate?
    
    // MARK: - Init
    init(id: String, date: String, owner: String) {
        self.id = id
        self.date = date
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
    }
    
    private func setUpNavigation() {
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .done, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .label
        navigationItem.title = "Календарь"
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        self.dismiss(animated: true)
    }
    
    private func configureCalendar() {
        let calendarView = UICalendarView()
        
        let dateSelection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = dateSelection
        calendarView.delegate = self
        
        calendarView.calendar = .current
        calendarView.locale = .current
        
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(calendarView)
        
        NSLayoutConstraint.activate([
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            calendarView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            calendarView.heightAnchor.constraint(equalToConstant: view.frame.height / 2)
        ])
    }
}
