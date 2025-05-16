//
//  SavedVideosListTableViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 02.06.2024.
//

import UIKit
import SafariServices

// MARK: - UITableViewDelegate
extension SavedVideosListTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        playCurrentVideo(url: viewModel.videoItem(index: indexPath.row).url)
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if tableView.isEditing {
            viewModel.updateVideos(videos: viewModel.videos, sourceIndexPath.row, destinationIndexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteVideo(video: viewModel.videoItem(index: indexPath.row))
        }
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            
            let editAction = UIAction(title: "Редактировать", image: UIImage(named: "edit")) { _ in
                self.video = self.viewModel.videoItem(index: indexPath.row)
                self.showEditAlert()
            }
            
            let positionAction = UIAction(title: "Позиция", image: UIImage(named: "number")) { _ in
                tableView.isEditing.toggle()
                self.setUpEditButton()
            }
            
            let shareAction = UIAction(title: "Поделиться", image: UIImage(named: "share")) { _ in
                self.shareInfo(image: UIImage(named: "play icon")!, title: "\(self.viewModel.videoItem(index: indexPath.row).name)", text: "\(self.viewModel.videoItem(index: indexPath.row).url)")
            }
            
            return UIMenu(title: self.viewModel.videoItem(index: indexPath.row).date, children: [
                editAction,
                positionAction,
                shareAction
            ])
        }
    }
}

// MARK: - UITableViewDataSource
extension SavedVideosListTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.videosCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let document = viewModel.videoItem(index: indexPath.row)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SavedVideoTableViewCell.identifier, for: indexPath) as? SavedVideoTableViewCell else {return UITableViewCell()}
        cell.configure(video: document)
        return cell
    }
}

extension SavedVideosListTableViewController {
    
    func showEditAlert() {
        
        let alertVC = UIAlertController(title: viewModel.createEditAlertMessage().0, message: viewModel.createEditAlertMessage().1, preferredStyle: .alert)
        
        alertVC.addTextField { (textField) in
            textField.placeholder = "Название видео"
            textField.text = self.video.name
        }
        
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { _ in
            if let name = alertVC.textFields![0].text {
                if !name.isEmpty {
                    self.viewModel.editVideo(video: self.video, name: name)
                }
            }
        }
        
        let cancel = UIAlertAction(title: "Отмена", style: .destructive)
        
        alertVC.addAction(saveAction)
        alertVC.addAction(cancel)
        
        SpeechSynthesizerManager.shared.checkIsSaying(text: "\(alertVC.title ?? "") \(alertVC.message ?? "")")
        present(alertVC, animated: true)
    }
    
    @objc func showAddVideoAlert() {
        
        let alertVC = UIAlertController(title: viewModel.createAddAlertMessage().0, message: viewModel.createAddAlertMessage().1, preferredStyle: .alert)
        
        alertVC.addTextField { (textField) in
            textField.placeholder = "URL"
        }
        
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { _ in
            if let url = alertVC.textFields![0].text, !url.isEmpty {
                if let urlPath = URL(string: url) {
                    let video = VideoModel()
                    video.url = urlPath.absoluteString
                    video.name = self.viewModel.getCurrentDate()
                    video.date = self.viewModel.getCurrentDate()
                    self.viewModel.saveVideo(video: video)
                }
            } else {
                let ok = UIAlertAction(title: "ОК", style: .default) { _ in  self.showAddVideoAlert()
                }
                self.showAlert(title: self.viewModel.createAlertMessage().0, message: self.viewModel.createAlertMessage().1, actions: [ok])
            }
        }
        
        let cancel = UIAlertAction(title: "Отмена", style: .destructive)
        
        alertVC.addAction(saveAction)
        alertVC.addAction(cancel)
        
        SpeechSynthesizerManager.shared.checkIsSaying(text: "\(alertVC.title ?? "") \(alertVC.message ?? "")")
        present(alertVC, animated: true)
    }
    
    func playCurrentVideo(url: String) {
        guard let videoUrl = URL(string: url) else {return}
        if UIApplication.shared.canOpenURL(videoUrl) {
            UserDefaults.standard.setValue(url, forKey: "last video")
            UIApplication.shared.open(videoUrl)
        }
    }
}
