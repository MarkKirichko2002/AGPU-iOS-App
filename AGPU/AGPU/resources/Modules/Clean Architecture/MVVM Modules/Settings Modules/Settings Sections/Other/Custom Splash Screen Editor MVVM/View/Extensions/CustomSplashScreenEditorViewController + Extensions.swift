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
        viewModel.color = color.title
        let screen = CustomSplashScreenModel()
        screen.id = 1
        screen.image = CustomIcon.image?.jpegData(compressionQuality: 1.0)
        screen.title = CustomTitleLabel.text!
        screen.color = color.title
        viewModel.saveCustomSplashScreen(screen: screen)
    }
}
