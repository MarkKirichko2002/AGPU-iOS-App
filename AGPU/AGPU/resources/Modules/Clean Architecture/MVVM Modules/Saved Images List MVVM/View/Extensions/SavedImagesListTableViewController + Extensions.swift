//
//  SavedImagesListTableViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 09.05.2024.
//

import UIKit

// MARK: - UITableViewDelegate
extension SavedImagesListTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let image = viewModel.imageItem(index: indexPath.row)
        let vc = ImageDetailViewController(image: image)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
        HapticsManager.shared.hapticFeedback()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteImage(image: viewModel.imageItem(index: indexPath.row))
        }
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            
            let shareAction = UIAction(title: "Поделиться", image: UIImage(named: "share")) { _ in
                let item = self.viewModel.imageItem(index: indexPath.row)
                guard let image = UIImage(data: item.image) else {return}
                self.ShareImage(image: image, title: "Изображение", text: item.date)
            }
            
            return UIMenu(title: self.viewModel.imageItem(index: indexPath.row).date, children: [
                shareAction
            ])
        }
    }
}

// MARK: - UITableViewDataSource
extension SavedImagesListTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.imagesCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let image = viewModel.imageItem(index: indexPath.row)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SavedImageTableViewCell.identifier, for: indexPath) as? SavedImageTableViewCell else {fatalError()}
        cell.configure(image: image)
        return cell
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension SavedImagesListTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {return}
        let model = ImageModel()
        model.image = imageData
        model.date = viewModel.getCurrentDate()
        self.viewModel.saveImage(image: model)
        self.dismiss(animated: true)
    }
}
