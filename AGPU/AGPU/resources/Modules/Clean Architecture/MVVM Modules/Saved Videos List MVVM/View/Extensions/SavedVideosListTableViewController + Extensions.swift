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
            
            let shareAction = UIAction(title: "Поделиться", image: UIImage(named: "share")) { _ in
                self.shareInfo(image: UIImage(named: "play icon")!, title: "\(self.viewModel.videoItem(index: indexPath.row).name)", text: "\(self.viewModel.videoItem(index: indexPath.row).url)")
            }
            
            return UIMenu(title: self.viewModel.videoItem(index: indexPath.row).date, children: [
                editAction,
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
        
        let alertVC = UIAlertController(title: "Изменить видео", message: "Вы точно хотите изменить название видео?", preferredStyle: .alert)
        
        alertVC.addTextField { (textField) in
            textField.placeholder = "Введите текст"
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
        
        present(alertVC, animated: true)
    }
    
    @objc func showAddVideoAlert() {
        
        let alertVC = UIAlertController(title: "Добавить видео", message: "Введите URL для видео", preferredStyle: .alert)
        
        alertVC.addTextField { (textField) in
            textField.placeholder = "Введите URL"
        }
        
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { _ in
            if let url = alertVC.textFields![0].text {
                if let urlPath = URL(string: url) {
                    let video = VideoModel()
                    video.url = urlPath.absoluteString
                    video.name = self.viewModel.getCurrentDate()
                    video.date = self.viewModel.getCurrentDate()
                    self.viewModel.saveVideo(video: video)
                }
            }
        }
        
        let cancel = UIAlertAction(title: "Отмена", style: .destructive)
        
        alertVC.addAction(saveAction)
        alertVC.addAction(cancel)
        
        present(alertVC, animated: true)
    }
    
    func playCurrentVideo(url: String) {
        if !url.contains("youtube") {
            playVideo(url: url)
        } else {
            guard let url = URL(string: url) else {return}
            let vc = SFSafariViewController(url: url)
            self.present(vc, animated: true)
        }
    }
}
