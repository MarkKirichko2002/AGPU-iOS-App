//
//  DocumentsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 13.08.2023.
//

import UIKit

class DocumentsListTableViewController: UITableViewController {
    
    private let service = HTMLParser()
    var documents = [DocumentModel]()
    var docs = [DocumentModel]()
    private var url = ""
    
    // MARK: - Init
    init(url: String) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUpTable()
        SetUpNavigation()
    }
    
    private func makeMenu()-> UIMenu {
        let formats = ["все", "pdf", "doc", "docx"]
        let actions = formats.map { format in
            return UIAction(title: format) { [weak self] _ in
                if format == "все" {
                    guard let self = self else { return }
                    self.documents = self.docs
                    self.tableView.reloadData()
                } else {
                    guard let self = self else { return }
                    self.documents = self.docs
                    self.documents = self.documents.filter { $0.format.lowercased() == format }
                    self.tableView.reloadData()
                }
            }
        }
        let menu = UIMenu(title: "форматы", options: .singleSelection, children: actions)
        return menu
    }

    private func SetUpNavigation() {
        navigationItem.title = "Методические материалы"
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .done, target: self, action: #selector(close))
        closeButton.tintColor = .black
        let sections = UIBarButtonItem(image: UIImage(named: "sections"), menu: makeMenu())
        sections.tintColor = .black
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.rightBarButtonItem = sections
    }
    
    @objc private func close() {
        self.dismiss(animated: true)
    }
    
    private func SetUpTable() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        service.ParseDocuments(url: self.url) { documents in
            DispatchQueue.main.async {
                self.documents = documents
                self.docs = documents
                self.tableView.reloadData()
            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = documents[indexPath.row].url
        let format = documents[indexPath.row].format.lowercased()
        switch format {
        case "pdf":
            let vc = PDFDocumentReaderViewController(url: url)
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        case "doc", "docx":
            let vc = WordDocumentReaderViewController(url: url)
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(documents[indexPath.row].name) (\(documents[indexPath.row].format))"
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        cell.textLabel?.numberOfLines = 0
        return cell
    }
}
