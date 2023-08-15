//
//  DocumentsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 13.08.2023.
//

import UIKit

class DocumentsListTableViewController: UITableViewController {
    
    private var url = ""
    
    // MARK: - сервисы
    private let viewModel: DocumentsListViewModel!
    
    // MARK: - Init
    init(url: String) {
        self.url = url
        self.viewModel = DocumentsListViewModel(url: url)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUpNavigation()
        SetUpTable()
        BindViewModel()
    }
    
    private func SetUpNavigation() {
        navigationItem.title = "Методические материалы"
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .done, target: self, action: #selector(close))
        closeButton.tintColor = .black
        let sections = UIBarButtonItem(image: UIImage(named: "sections"), menu: viewModel.makeMenu())
        sections.tintColor = .black
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.rightBarButtonItem = sections
    }
    
    @objc private func close() {
        viewModel.SendScreenClosedNotification()
        self.dismiss(animated: true)
    }
    
    private func SetUpTable() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func BindViewModel() {
        viewModel.GetDocuments()
        viewModel.registerDataChangedHandler {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = viewModel.documents[indexPath.row].url
        let format = viewModel.documents[indexPath.row].format.lowercased()
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
        return viewModel.documents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(viewModel.documents[indexPath.row].name) (\(viewModel.documents[indexPath.row].format))"
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        cell.textLabel?.numberOfLines = 0
        return cell
    }
}
