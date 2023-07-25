//
//  FacultyCathedraListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 24.07.2023.
//

import UIKit

class FacultyCathedraListTableViewController: UITableViewController {
    
    var faculty: AGPUFacultyModel
    
    @objc private let viewModel: FacultyCathedraListViewModel!
    
    // MARK: - Init
    init(
        faculty: AGPUFacultyModel
    ) {
        self.faculty = faculty
        self.viewModel = FacultyCathedraListViewModel(faculty: faculty)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Кафедры \(faculty.abbreviation)"
        tableView.register(UINib(nibName: FacultyCathedraTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: FacultyCathedraTableViewCell.identifier)
        BindViewModel()
    }
    
    private func BindViewModel() {
        viewModel.observation = observe(\.viewModel.isChanged) { _, _ in
            self.tableView.reloadData()
        }
    }
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil,
                                          actionProvider: {
            _ in
            
            let infoAction = UIAction(title: "узнать больше", image: UIImage(named: "info")) { _ in
                self.GoToWeb(url: self.faculty.cathedra[indexPath.row].url, title: "Кафедра \(self.faculty.abbreviation)", isSheet: true)
            }
            
            let manualAction = UIAction(title: "методические материалы", image: UIImage(named: "manual")) { _ in
                self.GoToWeb(url: self.faculty.cathedra[indexPath.row].manualUrl, title: "методические материалы", isSheet: true)
            }
            
            let mapAction = UIAction(title: "найти кафедру", image: UIImage(named: "search")) { _ in
                let vc = AGPUCurrentCathedraMapViewController(cathedra: self.faculty.cathedra[indexPath.row])
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            let shareAction = UIAction(title: "поделиться", image: UIImage(named: "share")) { _ in
                self.shareInfo(image: UIImage(named: self.faculty.icon)!, title: self.faculty.abbreviation, text: self.faculty.cathedra[indexPath.row].url)
            }
            
            return UIMenu(title: self.faculty.cathedra[indexPath.row].name, children: [
                infoAction,
                manualAction,
                mapAction,
                shareAction
            ])
        })
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.SelectCathedra(index: indexPath.row)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faculty.cathedra.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FacultyCathedraTableViewCell.identifier, for: indexPath) as? FacultyCathedraTableViewCell else {return UITableViewCell()}
        cell.tintColor = .systemGreen
        cell.accessoryType = viewModel.isCathedraSelected(index: indexPath.row)
        cell.CathedraName.textColor = viewModel.isCathedraSelectedColor(index: indexPath.row)
        cell.configure(cathedra: faculty.cathedra[indexPath.row], faculty: faculty)
        return cell
    }
}
