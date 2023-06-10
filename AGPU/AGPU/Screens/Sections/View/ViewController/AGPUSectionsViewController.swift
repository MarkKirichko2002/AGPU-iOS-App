//
//  AGPUSectionsViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 08.06.2023.
//

import UIKit
import SafariServices

// MARK: - AGPUSectionsViewControllerDelegate
protocol AGPUSectionsViewControllerDelegate: AnyObject {
    func subSectionWasSelected(subSection: AGPUSubSectionModel)
}

class AGPUSectionsViewController: UIViewController {

    private let sections = AGPUSections.sections
    weak var delegate: AGPUSectionsViewControllerDelegate?
    
    private let tableView = UITableView()
    private var vc = SFSafariViewController(url: URL(string: "https://www.apple.com/")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "ФГБОУ ВО «АГПУ»"
        SetUpTable()
        ObserveNotifications()
    }
    
    private func SetUpTable() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: AGPUSubSectionTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: AGPUSubSectionTableViewCell.identifier)
    }
    
    private func ObserveNotifications() {
        // Выбор раздела
        NotificationCenter.default.addObserver(forName: Notification.Name("ScrollToSection"), object: nil, queue: .main) { notification in
            
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: notification.object as? Int ?? 0), at: .top, animated: true)
        }
        // Выбор подраздела
        NotificationCenter.default.addObserver(forName: Notification.Name("SubSectionSelected"), object: nil, queue: .main) { notification in
            self.GoToWeb(url: notification.object as? String ?? "")
        }
    }
        
    func GoToWeb(url: String) {
        guard let url = URL(string: url) else {return}
        vc = SFSafariViewController(url: url)
        vc.modalPresentationStyle = .formSheet
        present(vc, animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension AGPUSectionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].subsections.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.subSectionWasSelected(subSection: sections[indexPath.section].subsections[indexPath.row])
        self.GoToWeb(url: self.sections[indexPath.section].subsections[indexPath.row].url)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AGPUSubSectionTableViewCell.identifier, for: indexPath) as? AGPUSubSectionTableViewCell else {return UITableViewCell()}
        cell.configure(subsection: sections[indexPath.section].subsections[indexPath.row])
        return cell
    }
}
