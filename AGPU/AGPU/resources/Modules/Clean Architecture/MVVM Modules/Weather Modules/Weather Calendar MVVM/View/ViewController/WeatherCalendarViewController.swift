//
//  WeatherCalendarViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 15.07.2024.
//

import UIKit
import MapKit

final class WeatherCalendarViewController: UIViewController {

    var selection: UICalendarSelectionSingleDate?
    var location: CLLocation
    
    weak var delegate: CalendarViewControllerDelegate?
    
    // MARK: - сервисы
    let viewModel = WeatherCalendarViewModel()
    
    let calendarView = UICalendarView()
    
    init(location: CLLocation) {
        self.location = location
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
        
        return UIMenu(title: "Календарь", children: [
            refreshAction,
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
    
    func bindViewModel() {
        viewModel.registerAlertHandler { title, message in
            self.showAlert(title: title, message: message, actions: [UIAlertAction(title: "ОК", style: .default)])
        }
    }
}
