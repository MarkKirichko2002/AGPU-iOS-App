//
//  CustomActivityItemSource.swift
//  AGPU
//
//  Created by Марк Киричко on 20.07.2023.
//

import UIKit
import LinkPresentation

class CustomActivityItemSource: NSObject, UIActivityItemSource {
    
    var title: String
    var text: String
    var image: UIImage
    
    init(
        title: String,
        text: String,
        image: UIImage
    ) {
        self.title = title
        self.text = text
        self.image = image
        super.init()
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return title
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        return text
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return image
    }
    
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        metadata.title = title
        metadata.originalURL = URL(fileURLWithPath: text)
        metadata.iconProvider = NSItemProvider(object: image)
        return metadata
    }
}
