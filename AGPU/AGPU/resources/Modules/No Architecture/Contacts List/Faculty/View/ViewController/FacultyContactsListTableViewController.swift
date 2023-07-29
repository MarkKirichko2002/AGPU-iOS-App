//
//  FacultyContactsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 29.07.2023.
//

import UIKit

class FacultyContactsListTableViewController: UITableViewController {

    private var faculty: AGPUFacultyModel!
    
    // MARK: - Init
    init(faculty: AGPUFacultyModel) {
        self.faculty = faculty
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Контакты \(faculty.abbreviation)"
        tableView.register(UINib(nibName: ContactsTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ContactsTableViewCell.identifier)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.makePhoneCall(phoneNumber: faculty.contacts[indexPath.row].phoneNumber)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faculty.contacts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactsTableViewCell.identifier, for: indexPath) as? ContactsTableViewCell else {return UITableViewCell()}
        cell.configure(contact: faculty.contacts[indexPath.row])
        return cell
    }
}
