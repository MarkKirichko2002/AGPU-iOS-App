//
//  CalendarDisciplineNameViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 26.04.2025.
//

import UIKit

protocol CalendarDisciplineNameViewControllerDelegate: AnyObject {
    func dateWasSelected(date: String, name: String)
}

final class CalendarDisciplineNameViewController: UIViewController {

    // MARK: - сервисы
    let viewModel: CalendarDisciplineNameViewModel
    
    var id: String = ""
    var subgroup: Int = 0
    var date: String = ""
    var owner: String = ""
    
    var name: String = ""
    
    var selection: UICalendarSelectionSingleDate?
    
    weak var delegate: CalendarDisciplineNameViewControllerDelegate?
    
    let calendarView = UICalendarView()
    
    // MARK: - Init
    init(id: String, date: String, owner: String, name: String) {
        self.id = id
        self.date = date
        self.owner = owner
        self.name = name
        self.viewModel = CalendarDisciplineNameViewModel(id: id, date: date, owner: owner, name: name)
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
        closeButton.tintColor = .label
        navigationItem.title = "Календарь"
        navigationItem.rightBarButtonItem = closeButton
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
    
    func bindViewModel() {
        viewModel.registerAlertHandler { name, date in
            if !name.isEmpty {
                self.showAlertVC(date: date, isFind: true)
            } else {
                self.showAlertVC(date: date, isFind: false)
            }
        }
    }
    
    func showAlertVC(date: String, isFind: Bool) {
        let choose = UIAlertAction(title: "Выбрать", style: .default) { _ in
            self.delegate?.dateWasSelected(date: date, name: self.name)
            self.dismiss(animated: true)
        }
        let cancel = UIAlertAction(title: "Отмена", style: .destructive)
        self.showAlert(title: isFind ? "Дисциплина найдена!" : "Дисциплина не найдена!", message: "(\(name)) \n\(date)", actions: [choose, cancel])
    }
}
