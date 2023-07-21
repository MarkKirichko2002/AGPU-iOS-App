//
//  CustomMusicListViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 21.07.2023.
//

import UIKit

protocol CustomMusicListViewModelProtocol {
    func GetMusicList()
    func DeleteMusic(index: Int)
    func musicListCount()-> Int
    func musicItem(index: Int)-> MusicModel
    func OnMusic(index: Int)
    func OffMusic(index: Int)
    func RestartMusic(index: Int)
    func ToggleMusic(index: Int, isChecked: Bool)
    func isMusicSelected(index: Int)-> UITableViewCell.AccessoryType
}
