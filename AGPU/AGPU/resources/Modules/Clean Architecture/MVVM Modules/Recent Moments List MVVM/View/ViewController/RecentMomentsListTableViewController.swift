//
//  RecentMomentsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 10.08.2023.
//

import UIKit

class RecentMomentsListTableViewController: UITableViewController {
    
    // MARK: - сервисы
    private let viewModel = RecentMomentsListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUpNavigation()
        SetUpTable()
    }
    
    private func SetUpNavigation() {
        navigationItem.title = "Недавние моменты"
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .black
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func closeScreen() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            NotificationCenter.default.post(name: Notification.Name("screen was closed"), object: nil)
        }
        dismiss(animated: true)
    }
    
    private func SetUpTable() {
        tableView.register(UINib(nibName: RecentMomentTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: RecentMomentTableViewCell.identifier)
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