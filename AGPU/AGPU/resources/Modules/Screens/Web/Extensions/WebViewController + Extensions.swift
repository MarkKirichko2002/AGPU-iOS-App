//
//  WebViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 06.07.2023.
//

import UIKit

// MARK: - UIScrollViewDelegate
extension WebViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        let position = CGPoint(x: 0, y: yOffset)
        UserDefaults.SaveData(object: position, key: "last position") {
            print("сохранено: \(position)")
        }
    }
}
