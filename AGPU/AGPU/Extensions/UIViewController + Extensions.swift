//
//  UIViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 21.06.2023.
//

import UIKit

extension UIViewController {
    
    func GoToWeb(url: String) {
        guard let url = URL(string: url) else {return}
        let vc = WebViewController(url: url)
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
}
