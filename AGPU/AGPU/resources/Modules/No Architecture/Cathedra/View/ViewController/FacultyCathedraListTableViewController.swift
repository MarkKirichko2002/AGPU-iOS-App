//
//  FacultyCathedraListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 24.07.2023.
//

import UIKit

class FacultyCathedraListTableViewController: UITableViewController {
    
    var faculty: AGPUFacultyModel
    
    // MARK: - Init
    init(
        faculty: AGPUFacultyModel
    ) {
        self.faculty = faculty
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Кафедры \(faculty.abbreviation)"
        tableView.register(UINib(nibName: FacultyCathedraTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: FacultyCathedraTableViewCell.identifier)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faculty.cathedra.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.GoToWeb(url: faculty.cathedra[indexPath.row].url, title: "Кафедра \(faculty.abbreviation)", isSheet: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FacultyCathedraTableViewCell.identifier, for: indexPath) as? FacultyCathedraTableViewCell else {return UITableViewCell()}
        cell.configure(cathedra: faculty.cathedra[indexPath.row], faculty: faculty)
        return cell
    }
}
