//
//  AGPUThemesListViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 13.07.2023.
//

import UIKit

// MARK: - SpaceWallpapersViewController
extension AGPUThemesListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return themes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AGPUThemeCollectionViewCell.identifier, for: indexPath) as? AGPUThemeCollectionViewCell else {return UICollectionViewCell()}
        cell.configure(with: themes[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension AGPUThemesListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                                 contextMenuConfigurationForItemAt indexPath: IndexPath,
                                 point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            let save = UIAction(title: "cохранить", image: UIImage(systemName: "photo")) { _ in
                if let cell = collectionView.cellForItem(at: indexPath) as? AGPUThemeCollectionViewCell {
                    if let image = cell.imageView.image {
                        let imageSaver = ImageSaver()
                        imageSaver.writeToPhotoAlbum(image: image)
                    }
                }
            }
            return UIMenu(title: "", children: [save])
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension AGPUThemesListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath)-> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width - 30) / 2
        return CGSize(width: width, height: width * 1.5)
    }
}


