//
//  RecentMomentsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 10.08.2023.
//

import UIKit

final class RecentMomentsListTableViewController: UITableViewController {
    
    // MARK: - сервисы
    private let viewModel = RecentMomentsListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUpNavigation()
        SetUpTable()
        BindViewModel()
    }
    
    private func SetUpNavigation() {
        navigationItem.title = "Недавние моменты"
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .black
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func closeScreen() {
        SendScreenWasClosedNotification()
        dismiss(animated: true)
    }
    
    private func SetUpTable() {
        tableView.register(UINib(nibName: RecentMomentTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: RecentMomentTableViewCell.identifier)
    }
    
    private func BindViewModel() {
        viewModel.registerAlertHandler { message, description in
            let ok = UIAlertAction(title: "ОК", style: .default)
            self.ShowAlert(title: message, message: description, actions: [ok])
        }
    }
    
    private func CheckLastWebPage() {
        viewModel.GetLastWebPage { page in
            self.ShowRecentPageScreen(page: page)
        }
    }
    
    private func CheckLastPDFDocument() {
        viewModel.GetLastPDFDocument { pdf in
            let vc = PDFLastPageViewController(pdf: pdf)
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                self.present(navVC, animated: true)
            }
        }
    }
    
    private func CheckLastWordDocument() {
        viewModel.GetLastWordDocument { document in
            let vc = WordRecentDocumentViewController(document: document)
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                self.present(navVC, animated: true)
            }
        }
    }
    
    private func CheckLastVideo() {
        viewModel.GetLastVideo { videoURL in
            self.PlayVideo(url: videoURL)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            CheckLastWebPage()
        case 1:
            CheckLastPDFDocument()
        case 2:
            CheckLastWordDocument()
        case 3:
            CheckLastVideo()
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RecentMomentsList.moments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecentMomentTableViewCell.identifier, for: indexPath) as? RecentMomentTableViewCell else {return UITableViewCell()}
        cell.configure(moment: RecentMomentsList.moments[indexPath.row])
        return cell
    }
}
