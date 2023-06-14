//
//  AGPUSectionsViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 08.06.2023.
//

import UIKit

class AGPUSectionsViewController: UIViewController {

    private let sections = AGPUSections.sections
    
    private let tableView = UITableView()

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
        
    private func GoToWeb(url: String) {
        guard let url = URL(string: url) else {return}
        let vc = WebViewController()
        vc.url = url
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension AGPUSectionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        header.backgroundColor = .secondarySystemBackground
        
        let imageView = UIImageView(image: UIImage(named: sections[section].icon))

        imageView.contentMode = .scaleAspectFit
        header.addSubview(imageView)
        imageView.frame = CGRect(x: 5, y: 5, width: 75, height: 75)
        
        let label = UILabel(frame: CGRect(x: 10 + imageView.frame.size.width, y: 5,
                                          width: header.frame.size.width - 15 - imageView.frame.size.width,
                                          height: header.frame.size.height-10))
        header.addSubview(label)
        label.text = sections[section].name
        label.font = .systemFont(ofSize: 17, weight: .black)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].subsections.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: Notification.Name("subsection"), object: sections[indexPath.section].subsections[indexPath.row])
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.GoToWeb(url: self.sections[indexPath.section].subsections[indexPath.row].url)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AGPUSubSectionTableViewCell.identifier, for: indexPath) as? AGPUSubSectionTableViewCell else {return UITableViewCell()}
        cell.configure(subsection: sections[indexPath.section].subsections[indexPath.row])
        return cell
    }
}
