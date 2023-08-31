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
        setUpNavigation()
        setUpTable()
    }
    
    private func setUpNavigation() {
        navigationItem.title = "Контакты \(faculty.abbreviation)"
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .black
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func closeScreen() {
         dismiss(animated: true)
    }
    
    private func setUpTable() {
        tableView.register(UINib(nibName: ContactsTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ContactsTableViewCell.identifier)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = faculty.contacts[indexPath.row]
        self.makePhoneCall(phoneNumber: contact.phoneNumber)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faculty.contacts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contact = faculty.contacts[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactsTableViewCell.identifier, for: indexPath) as? ContactsTableViewCell else {return UITableViewCell()}
        cell.configure(contact: contact)
        return cell
    }
}
