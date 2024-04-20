//
//  CustomSplashScreenEditorViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 20.04.2024.
//

import UIKit

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension CustomSplashScreenEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        CustomIcon.image = image
        self.dismiss(animated: true)
    }
}

// MARK: - SplashScreenBackgroundColorsListTableViewControllerDelegate
extension CustomSplashScreenEditorViewController: SplashScreenBackgroundColorsListTableViewControllerDelegate {
    
    func colorWasSelected(color: BackgroundColors) {
        CustomTitleLabel.textColor = .white
        view.backgroundColor = color.color
        viewModel.colorOption = color
    }
}
