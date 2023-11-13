//
//  AGPUWallpapersListViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 13.07.2023.
//

import UIKit

// MARK: - UICollectionViewDataSource
extension AGPUWallpapersListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let imagesCount = AGPUThemes.themes.count
        return imagesCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let image = AGPUThemes.themes[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AGPUWallpaperCollectionViewCell.identifier, for: indexPath) as? AGPUWallpaperCollectionViewCell else {return UICollectionViewCell()}
        cell.configure(with: image)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension AGPUWallpapersListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                                 contextMenuConfigurationForItemAt indexPath: IndexPath,
                                 point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            let save = UIAction(title: "Сохранить", image: UIImage(named: "download")) { _ in
                if let cell = collectionView.cellForItem(at: indexPath) as? AGPUWallpaperCollectionViewCell {
                    if let image = cell.imageView.image {
                        let imageSaver = ImageSaver()
                        imageSaver.writeToPhotoAlbum(image: image)
                    }
                }
            }
            
            let share = UIAction(title: "Поделиться", image: UIImage(named: "share")) { _ in
                if let cell = collectionView.cellForItem(at: indexPath) as? AGPUWallpaperCollectionViewCell {
                    if let image = cell.imageView.image {
                        self.ShareImage(image: image, title: "АГПУ", text: "обоя")
                    }
                }
            }
            return UIMenu(title: "", children: [save, share])
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension AGPUWallpapersListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath)-> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width - 30) / 2
        return CGSize(width: width, height: width * 1.5)
    }
}
