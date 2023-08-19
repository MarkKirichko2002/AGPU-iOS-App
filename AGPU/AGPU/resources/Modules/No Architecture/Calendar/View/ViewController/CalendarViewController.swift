//
//  CalendarViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 12.07.2023.
//

import UIKit
import FSCalendar

final class CalendarViewController: UIViewController {

    private let Calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.translatesAutoresizingMaskIntoConstraints = false
        return calendar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        SetUpNavigation()
        SetUpCalendar()
    }
    
    private func SetUpNavigation() {
        navigationItem.title = "Календарь"
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .done, target: self, action: #selector(close))
        closeButton.tintColor = .black
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func close() {
        self.dismiss(animated: true)
    }
    
    private func SetUpCalendar() {
        view.addSubview(Calendar)
        Calendar.delegate = self
        makeConstraints()
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            Calendar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            Calendar.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            Calendar.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            Calendar.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
}
