//
//  SpringImageView + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 19.07.2023.
//

import UIKit

// MARK: - UIContextMenuInteractionDelegate
extension SpringImageView: UIContextMenuInteractionDelegate {
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                                configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil,
                                          actionProvider: {
                suggestedActions in
            let saveAction = UIAction(title: "Cохранить", image: UIImage(named: "download")) { _ in
                if let image = self.image {
                    let imageSaver = ImageSaver()
                    imageSaver.writeToPhotoAlbum(image: image)
                }
            }
                
            return UIMenu(title: "", children: [saveAction])
        })
    }
}
