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

class TeachersListTableViewController: UITableViewController {

    let service = DBService(response: .teachers)
    
    var teachers = [Teacher]()
    var id = 1
    
    weak var delegate: TeachersListTableViewControllerDelegate?
    
    init(id: Int) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        getData()
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
    
    private func getData() {
        service.id = id
        DispatchQueue.global().async {
            self.service.getData()
        }
        DispatchQueue.main.async {
            self.service.getTeachers { teachers in
                self.teachers = teachers
                self.tableView.reloadData()
            }
        }
    }
    
    private func getSavedId()-> String {
        let id = UserDefaults.standard.object(forKey: "group") as? String ?? "ВМ-ИВТ-2-1"
        return id
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let teacher = teachers[indexPath.row]
        let abbreviation = "\(teacher.lastName) \(teacher.firstName) \(teacher.fatherName ?? "")".teacherAbbreviation()
        delegate?.teacherWasSelected(teacher: abbreviation)
        navigationController?.popViewController(animated: true)
        HapticsManager.shared.hapticFeedback()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teachers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let teacher = teachers[indexPath.row]
        let abbreviation = "\(teacher.lastName) \(teacher.firstName) \(teacher.fatherName ?? "")".teacherAbbreviation()
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.tintColor = .systemGreen
        cell.textLabel?.text = abbreviation
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        cell.textLabel?.textColor = abbreviation == getSavedId() ? .systemGreen : .label
        cell.accessoryType = abbreviation == getSavedId() ? .checkmark : .none
        return cell
    }
}
