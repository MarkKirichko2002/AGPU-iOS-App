//
//  AddMusicViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 30.06.2023.
//

import UIKit

final class AddMusicViewController: UIViewController {

    var music = MusicModel()
    var image = UIImage()
    
    // MARK: - сервисы
    private let realmManager = RealmManager()
    
    // MARK: - UI
    @IBOutlet var TitleTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func AddMusicFile() {
        let fileService = FileService()
        fileService.delegate = self
        fileService.vc = self
        fileService.importFiles()
    }
    
    @IBAction func AddMusicImage() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @IBAction func SaveMusic() {
        music.name = TitleTextField.text!
        if music.name != "" && music.fileName != "" {
            realmManager.saveMusic(music: music, image: image)
            NotificationCenter.default.post(name: Notification.Name("Music Added"), object: nil)
            self.dismiss(animated: true)
        }
    }
}