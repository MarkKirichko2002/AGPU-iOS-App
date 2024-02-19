//
//  DocumentsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 19.02.2024.
//

import UIKit

class DocumentsListTableViewController: UITableViewController {

    // MARK: - сервисы
    private let viewModel = DocumentsListViewModel()
    
    var document = DocumentModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        
        let titleView = CustomTitleView(image: "document", title: "Документы", frame: .zero)
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        let backButton = UIBarButtonItem(customView: button)
        
        navigationItem.titleView = titleView
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func back() {
        sendScreenWasClosedNotification()
        navigationController?.popViewController(animated: true)
    }
    
    private func setUpTable() {
        tableView.register(UINib(nibName: DocumentTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: DocumentTableViewCell.identifier)
    }
    
    private func bindViewModel() {
        viewModel.getDocuments()
        viewModel.registerDataChangedHandler {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let document = viewModel.documentItem(index: indexPath.row)
        if document.format == "pdf" {
            let vc = PDFDocumentReaderViewController(url: document.url)
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            present(navVC, animated: true)
        } else {
            let vc = WordDocumentReaderViewController(url: document.url)
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            present(navVC, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteDocument(document: viewModel.documentItem(index: indexPath.row))
        }
    }
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            
            let shareAction = UIAction(title: "Поделиться", image: UIImage(named: "share")) { _ in
                self.shareInfo(image: UIImage(named: "document")!, title: "\(self.viewModel.documentItem(index: indexPath.row).name)", text: "\(self.viewModel.documentItem(index: indexPath.row).url)")
            }
            
            let editAction = UIAction(title: "Редактировать", image: UIImage(named: "edit")) { _ in
                self.document = self.viewModel.documentItem(index: indexPath.row)
                self.showEditAlert()
            }
            
            return UIMenu(title: self.viewModel.documentItem(index: indexPath.row).name, children: [
                shareAction,
                editAction
            ])
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.documentsCount()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let document = viewModel.documentItem(index: indexPath.row)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DocumentTableViewCell.identifier, for: indexPath) as? DocumentTableViewCell else {return UITableViewCell()}
        cell.configure(document: document)
        return cell
    }
}

extension DocumentsListTableViewController {
    
    func showEditAlert() {
        
        let alertVC = UIAlertController(title: "Изменить документ", message: "Вы точно хотите изменить название документа", preferredStyle: .alert)
        
        alertVC.addTextField { (textField) in
            textField.placeholder = "Введите текст"
        }
        
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { _ in
            if let name = alertVC.textFields![0].text {
                if !name.isEmpty {
                    self.viewModel.editDocument(document: self.document, name: name)
                }
            }
        }
        
        let cancel = UIAlertAction(title: "Отмена", style: .destructive)
        
        alertVC.addAction(saveAction)
        alertVC.addAction(cancel)
        
        present(alertVC, animated: true)
    }
}
