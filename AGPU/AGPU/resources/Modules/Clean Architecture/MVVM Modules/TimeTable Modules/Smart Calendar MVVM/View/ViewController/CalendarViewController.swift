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
    let viewModel = CalendarViewModel()
    
    var id: String = ""
    var date: String = ""
    var owner: String = ""
    
    // MARK: - UI
    private let calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.appearance.titleDefaultColor = .label
        calendar.backgroundColor = .systemBackground
        calendar.translatesAutoresizingMaskIntoConstraints = false
        return calendar
    }()
    
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
        setUpCalendar()
    }
    
    private func setUpNavigation() {
        let titleView = CustomTitleView(image: "calendar icon", title: "Календарь", frame: .zero)
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .done, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .label
        navigationItem.titleView = titleView
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        self.dismiss(animated: true)
    }
    
    private func setUpCalendar() {
        view.addSubview(calendar)
        calendar.delegate = self
        makeConstraints()
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            calendar.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            calendar.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            calendar.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
}
