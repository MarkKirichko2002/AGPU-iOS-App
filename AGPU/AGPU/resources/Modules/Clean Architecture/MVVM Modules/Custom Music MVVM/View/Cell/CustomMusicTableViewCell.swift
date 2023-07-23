//
//  CustomMusicTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 01.07.2023.
//

import UIKit

final class CustomMusicTableViewCell: UITableViewCell {

    static let identifier = "CustomMusicTableViewCell"
    
    @IBOutlet var CustomMusicImage: SpringImageView!
    @IBOutlet var CustomMusicName: UILabel!
    @IBOutlet var CustomMusicDuration: UILabel!
    
    func configure(music: MusicModel) {
        CustomMusicImage.image = UIImage(data: music.image)
        CustomMusicName.text = music.name
        CustomMusicDuration.text = "\(music.duration.formatTime())"
        self.backgroundColor = .clear
    }
}
