//
//  NewsPagesListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 18.08.2023.
//

import UIKit

class NewsPagesListTableViewController: UITableViewController {
    
    private var currentPage: Int = 0
    private var countPages: Int = 0
    private var faculty: AGPUFacultyModel?
    
    private var pages = [Int]()
    
    // MARK: - Init
    init(currentPage: Int, countPages: Int, faculty: AGPUFacultyModel?) {
        self.currentPage = currentPage
        self.countPages = countPages
        self.faculty = faculty
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUpNavigation()
        SetUpTable()
    }
    
    private func SetUpNavigation() {
        navigationItem.title = "Выберите страницу"
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .black
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func closeScreen() {
        dismiss(animated: true)
    }
    
    private func SetUpTable() {
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        let countPages = self.countPages
            for i in 1...countPages {
            pages.append(i)
        }
        self.tableView.reloadData()
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            let indexPath = IndexPath(row: self.currentPage - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let page = pages[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        NotificationCenter.default.post(name: Notification.Name("page"), object: page)
        currentPage = page
        self.tableView.reloadData()
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            self.dismiss(animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let page = pages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.tintColor = .systemGreen
        cell.textLabel?.text = "страница \(page)"
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        cell.textLabel?.textColor = currentPage == page ? .systemGreen : .black
        cell.accessoryType = currentPage == page ? .checkmark : .none
        return cell
    }
}
