//
//  RecentPageViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 28.07.2023.
//

import Foundation

protocol RecentPageViewModelProtocol {
    func GetLastPosition(currentUrl: String, completion: @escaping(CGPoint)->Void)
}
