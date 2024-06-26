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
    
    var selection: UICalendarSelectionSingleDate?
    
    weak var delegate: CalendarViewControllerDelegate?
    
    let calendarView = UICalendarView()
    
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
        let options = UIBarButtonItem(image: UIImage(named: "sections"), menu: setUpMenu())
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .done, target: self, action: #selector(closeScreen))
        options.tintColor = .label
        closeButton.tintColor = .label
        navigationItem.title = "Календарь"
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.rightBarButtonItem = options
    }
    
    private func setUpMenu()-> UIMenu {
        
        let refreshAction = UIAction(title: "Сбросить") { _ in
            self.refresh()
        }
        
        let datesList = UIAction(title: "Даты") { _ in
            let vc = DatesListViewController(id: self.id, owner: self.owner)
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        let recentDatesList = UIAction(title: "Недавние") { _ in
            let vc = RecentDatesListViewController(id: self.id, owner: self.owner)
            vc.delegate = self
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        return UIMenu(title: "Календарь", children: [
            refreshAction,
            datesList,
            recentDatesList
        ])
    }
    
    @objc private func refresh() {
        if self.selection?.selectedDate != nil {
            self.selection?.selectedDate = nil
            HapticsManager.shared.hapticFeedback()
        }
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        self.dismiss(animated: true)
    }
    
    private func configureCalendar() {
        
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
            calendarView.topAnchor.constraint(equalTo: view.topAnchor),
            calendarView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
