//
//  CustomActivityItemSource.swift
//  AGPU
//
//  Created by Марк Киричко on 20.07.2023.
//

import UIKit
import LinkPresentation

enum ActivityItemType {
    case url
    case image
}

class CustomActivityItemSource: NSObject, UIActivityItemSource {
    
    var title: String
    var text: String
    var image: UIImage
    var type: ActivityItemType
    
    init(
        title: String,
        text: String,
        image: UIImage,
        type: ActivityItemType
    ) {
        self.title = title
        self.text = text
        self.image = image
        self.type = type
        super.init()
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return title
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        return text
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        switch type {
        case .url:
            return text
        case .image:
            return image
        }
    }
    
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        metadata.title = title
        metadata.originalURL = URL(fileURLWithPath: text)
        metadata.iconProvider = NSItemProvider(object: image)
        return metadata
    }
}
