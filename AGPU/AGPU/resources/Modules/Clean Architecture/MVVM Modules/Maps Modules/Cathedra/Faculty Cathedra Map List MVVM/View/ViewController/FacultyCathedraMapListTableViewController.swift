//
//  FacultyCathedraMapListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 13.12.2023.
//

import UIKit

class FacultyCathedraMapListTableViewController: UITableViewController {

    var viewModel: FacultyCathedraMapListViewModel?
    
    init(faculty: AGPUFacultyModel?) {
        self.viewModel = FacultyCathedraMapListViewModel(faculty: faculty)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        navigationItem.title = "Выберите факультет"
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .plain, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .label
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        dismiss(animated: true)
    }
    
    private func setUpTable() {
        tableView.register(UINib(nibName: AGPUFacultyTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: AGPUFacultyTableViewCell.identifier)
    }
    
    private func bindViewModel() {
        viewModel?.registerDataChangedHandler {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        viewModel?.registerFacultySelectedHandler {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                self.dismiss(animated: true)
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AGPUFaculties.faculties.count - 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AGPUFacultyTableViewCell.identifier, for: indexPath) as? AGPUFacultyTableViewCell else {return UITableViewCell()}
        cell.delegate = self
        cell.AGPUFacultyName.textColor = viewModel?.isCurrentFaculty(index: indexPath.row) ?? false ? .systemGreen : .label
        cell.accessoryType = viewModel?.isCurrentFaculty(index: indexPath.row) ?? false ? .checkmark : .none
        cell.configure(faculty: AGPUFaculties.faculties[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.chooseFaculty(index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension FacultyCathedraMapListTableViewController: AGPUFacultyTableViewCellDelegate {
    
    func openFacultyInfo(faculty: AGPUFacultyModel) {
        self.goToWeb(url: faculty.url, image: faculty.icon, title: faculty.abbreviation, isSheet: false, isNotify: false)
        HapticsManager.shared.hapticFeedback()
    }
}
