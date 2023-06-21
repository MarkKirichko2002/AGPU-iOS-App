//
//  AudioPlayerProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 21.06.2023.
//

import Foundation

protocol AudioPlayerProtocol {
    func PlaySound(resource: String)
    func StopSound(resource: String)
}
