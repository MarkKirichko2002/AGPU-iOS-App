//
//  FacultyCathedraMapListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 13.12.2023.
//

import UIKit

final class FacultyCathedraMapListTableViewController: UITableViewController {

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
    }
    
    private func setUpNavigation() {
        let titleView = CustomTitleView(image: "АГПУ", title: viewModel?.titleForNavigation() ?? "", frame: .zero)
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .plain, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .label
        navigationItem.titleView = titleView
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        dismiss(animated: true)
    }
    
    private func setUpTable() {
        tableView.register(UINib(nibName: AGPUFacultyTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: AGPUFacultyTableViewCell.identifier)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfFaculties() ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AGPUFacultyTableViewCell.identifier, for: indexPath) as? AGPUFacultyTableViewCell else {return UITableViewCell()}
        cell.delegate = self
        cell.configure(faculty: AGPUFaculties.faculties[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension FacultyCathedraMapListTableViewController: AGPUFacultyTableViewCellDelegate {
    
    func openFacultyInfo(faculty: AGPUFacultyModel) {
        self.goToWeb(url: faculty.url, image: faculty.icon, title: faculty.abbreviation, isSheet: false, isNotify: false)
        HapticsManager.shared.hapticFeedback()
    }
}
