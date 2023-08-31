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
        setUpNavigation()
        setUpTable()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        navigationItem.title = "Недавние моменты"
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .black
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func closeScreen() {
        sendScreenWasClosedNotification()
        dismiss(animated: true)
    }
    
    private func setUpTable() {
        tableView.register(UINib(nibName: RecentMomentTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: RecentMomentTableViewCell.identifier)
    }
    
    private func bindViewModel() {
        viewModel.registerAlertHandler { message, description in
            let ok = UIAlertAction(title: "ОК", style: .default)
            self.showAlert(title: message, message: description, actions: [ok])
        }
    }
    
    private func checkLastWebPage() {
        viewModel.getLastWebPage { page in
            self.showRecentPageScreen(page: page)
        }
    }
    
    private func checkLastPDFDocument() {
        viewModel.getLastPDFDocument { pdf in
            let vc = PDFLastPageViewController(pdf: pdf)
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                self.present(navVC, animated: true)
            }
        }
    }
    
    private func checkLastWordDocument() {
        viewModel.getLastWordDocument { document in
            let vc = WordRecentDocumentViewController(document: document)
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                self.present(navVC, animated: true)
            }
        }
    }
    
    private func checkLastVideo() {
        viewModel.getLastVideo { videoURL in
            self.playVideo(url: videoURL)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            checkLastWebPage()
        case 1:
            checkLastPDFDocument()
        case 2:
            checkLastWordDocument()
        case 3:
            checkLastVideo()
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RecentMomentsList.moments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let moment = RecentMomentsList.moments[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecentMomentTableViewCell.identifier, for: indexPath) as? RecentMomentTableViewCell else {return UITableViewCell()}
        cell.configure(moment: moment)
        return cell
    }
}
