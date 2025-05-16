//
//  TeachersListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 18.07.2024.
//

import UIKit

protocol TeachersListTableViewControllerDelegate: AnyObject {
    func teacherWasSelected(teacher: String)
}

final class TeachersListTableViewController: UITableViewController {

    var teachers = [String]()
    var selectedTeacher = ""
    weak var delegate: TeachersListTableViewControllerDelegate?
    
    // MARK: - сервисы
    private let settingsManager = SettingsManager()
    
    init(id: Int) {
        self.teachers = Departments.departments[id - 1].teachers
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        setUpData()
    }
    
    private func setUpNavigation() {
        navigationItem.title = "Преподаватели"
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
    
    private func setUpTable() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func setUpData() {
        selectedTeacher = settingsManager.getSavedID()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let teacher = teachers[indexPath.row]
        let abbreviation = teacher.teacherAbbreviation()
        selectedTeacher = abbreviation
        NotificationCenter.default.post(name: Notification.Name("option was selected"), object: nil)
        NotificationCenter.default.post(name: Notification.Name("user status"), object: nil)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            self.delegate?.teacherWasSelected(teacher: abbreviation)
            self.navigationController?.popViewController(animated: true)
        }
        tableView.reloadData()
        HapticsManager.shared.hapticFeedback()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teachers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let teacher = teachers[indexPath.row]
        let abbreviation = teacher.teacherAbbreviation()
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.tintColor = .systemGreen
        cell.textLabel?.text = abbreviation
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        cell.textLabel?.textColor = abbreviation == selectedTeacher ? .systemGreen : .label
        cell.accessoryType = abbreviation == selectedTeacher ? .checkmark : .none
        return cell
    }
}
