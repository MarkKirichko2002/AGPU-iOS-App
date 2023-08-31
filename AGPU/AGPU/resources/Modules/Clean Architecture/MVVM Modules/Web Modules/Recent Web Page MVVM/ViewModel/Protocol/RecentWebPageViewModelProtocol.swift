//
//  RecentWebPageViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 28.07.2023.
//

import Foundation

protocol RecentWebPageViewModelProtocol {
    func getRecentPosition(currentUrl: String, completion: @escaping(CGPoint)->Void)
}
