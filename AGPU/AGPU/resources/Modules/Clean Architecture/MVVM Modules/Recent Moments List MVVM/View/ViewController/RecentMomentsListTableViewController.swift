//
//  RecentMomentsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 10.08.2023.
//

import UIKit
import MapKit

final class RecentMomentsListTableViewController: UITableViewController {
    
    // MARK: - сервисы
    private let viewModel = RecentMomentsListViewModel()
    
    var isNotify = false
    weak var delegate: ScreenClosedDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        let titleView = CustomTitleView(image: "time", title: "Недавние моменты", frame: .zero)
        navigationItem.titleView = titleView
        setUpCloseButton()
    }
    
    func setUpCloseButton() {
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .done, target: self, action: #selector(close))
        closeButton.tintColor = .label
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func close() {
        if isNotify {
            delegate?.screenWasClosed()
        } else {
            HapticsManager.shared.hapticFeedback()
        }
        dismiss(animated: true)
    }
    
    private func setUpTable() {
        tableView.register(UINib(nibName: RecentMomentTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: RecentMomentTableViewCell.identifier)
    }
    
    private func bindViewModel() {
        viewModel.registerAlertHandler { message, description in
            self.showAlert(title: message, message: description, actions: [UIAlertAction(title: "ОК", style: .default)])
        }
    }
    
    private func checkLastWebPage() {
        viewModel.getLastWebPage { page in
            HapticsManager.shared.hapticFeedback()
            self.showRecentPageScreen(page: page)
        }
    }
    
    private func checkLastArticle() {
        viewModel.getLastWebArticle { article in
            HapticsManager.shared.hapticFeedback()
            self.showRecentPageScreen(page: article)
        }
    }
    
    private func checkLastPDFDocument() {
        viewModel.getLastPDFDocument { pdf in
            let vc = PDFLastPageViewController(pdf: pdf)
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                HapticsManager.shared.hapticFeedback()
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
                HapticsManager.shared.hapticFeedback()
                self.present(navVC, animated: true)
            }
        }
    }
    
    private func checkLastTimetable() {
        viewModel.getLastTimetable { group, date, owner in
            let vc = CurrentDateTimeTableDayListTableViewController(id: group, date: date, owner: owner)
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                HapticsManager.shared.hapticFeedback()
                self.present(navVC, animated: true)
            }
        }
    }
    
    private func checkLastVideo() {
        viewModel.getLastVideo { videoURL in
            guard let video = URL(string: videoURL) else {return}
            if UIApplication.shared.canOpenURL(video) {
                UserDefaults.standard.setValue(videoURL, forKey: "last video")
                UIApplication.shared.open(video)
            } else {
                self.playLocalVideo(video: videoURL)
            }
        }
    }
    
    private func checkLastLocation() {
        viewModel.getLastLocation { location in
            let vc = RecentBuildingViewController()
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                HapticsManager.shared.hapticFeedback()
                self.present(navVC, animated: true)
            }
        }
    }
    
    func goToShareScreen(annotation: MKAnnotation) {
        let vc = ShareLocationAppsViewController(annotation: annotation)
        vc.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async {
            HapticsManager.shared.hapticFeedback()
            self.present(vc, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            
            let moment = self.viewModel.momentItem(index: indexPath.row)
            
            let resetAction = UIAction(title: "Сбросить", image: UIImage(named: "refresh")) { _ in
                self.viewModel.resetData(index: indexPath.row)
            }
            
            let shareAction = UIAction(title: "Поделиться", image: UIImage(named: "share")) { _ in
                if moment.id == 6 {
                    self.viewModel.contentForShare(index: indexPath.row) { image in
                        let info = self.viewModel.getRecentTimetableInfo()
                        self.ShareImage(image: image as? UIImage ?? UIImage(), title: info.0, text: info.1)
                        HapticsManager.shared.hapticFeedback()
                    }
                } else if moment.id == 7 {
                    self.viewModel.contentForShare(index: indexPath.row) { location in
                        self.goToShareScreen(annotation: location as! MKAnnotation)
                    }
                } else {
                    self.viewModel.contentForShare(index: indexPath.row) { item in
                        self.shareInfo(image: UIImage(named: "АГПУ")!, title: moment.name, text: item as? String ?? "нет текста")
                    }
                }
            }
            
            return UIMenu(title: self.viewModel.momentItem(index: indexPath.row).name, children: [
                resetAction,
                shareAction
            ])
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            checkLastWebPage()
        case 1:
            checkLastArticle()
        case 2:
            checkLastPDFDocument()
        case 3:
            checkLastWordDocument()
        case 4:
            checkLastTimetable()
        case 5:
            checkLastVideo()
        case 6:
            checkLastLocation()
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.momentsCount()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let moment = viewModel.momentItem(index: indexPath.row)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecentMomentTableViewCell.identifier, for: indexPath) as? RecentMomentTableViewCell else {return UITableViewCell()}
        cell.configure(moment: moment)
        return cell
    }
}
