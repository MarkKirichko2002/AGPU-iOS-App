//
//  UITableView + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 20.07.2023.
//

import UIKit

extension UITableView {
    
    func toImage() -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: contentSize)
        
        var fullTableViewImage: UIImage?
        
        let contentOffset = self.contentOffset
        let savedFrame = self.frame
        
        self.contentOffset = .zero
        self.frame = CGRect(origin: .zero, size: contentSize)
        
        fullTableViewImage = renderer.image { context in
            self.layer.render(in: context.cgContext)
        }
        
        self.contentOffset = contentOffset
        self.frame = savedFrame
        
        return fullTableViewImage
    }
}
