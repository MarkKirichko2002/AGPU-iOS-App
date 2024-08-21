//
//  CalendarARViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 21.08.2024.
//

import UIKit

protocol CalendarARViewControllerDelegate: AnyObject {
    func imageWasCreated(image: UIImage, date: String)
}

final class CalendarARViewController: UIViewController {

    // MARK: - сервисы
    let viewModel: CalendarARViewModel!
    
    var id: String = ""
    var date: String = ""
    var owner: String = ""
    
    var selection: UICalendarSelectionSingleDate?
    
    weak var delegate: CalendarARViewControllerDelegate?
    
    let calendarView = UICalendarView()
    
    // MARK: - Init
    init(id: String, date: String, owner: String) {
        self.id = id
        self.date = date
        self.owner = owner
        self.viewModel = CalendarARViewModel(id: id, owner: owner)
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
        view.addSubview(calendarView)
        
        NSLayoutConstraint.activate([
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            calendarView.topAnchor.constraint(equalTo: view.topAnchor),
            calendarView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.registerImageCreatedHandler { image, date in
            DispatchQueue.main.async {
                self.dismiss(animated: true)
                self.delegate?.imageWasCreated(image: image, date: date)
            }
        }
    }
}
