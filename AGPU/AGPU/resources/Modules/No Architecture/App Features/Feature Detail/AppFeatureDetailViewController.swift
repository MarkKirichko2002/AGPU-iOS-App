//
//  AppFeatureDetailViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 22.07.2023.
//

import UIKit

final class AppFeatureDetailViewController: UIViewController {
    
    var feature: AppFeatureModel?
    
    @IBOutlet var FeatureName: UILabel!
    @IBOutlet var FeatureDescription: UITextView!

    // MARK: - Init
    init(
        feature: AppFeatureModel
    ) {
        self.feature = feature
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let feature = feature {
            FeatureName.text = feature.name
            FeatureDescription.text = feature.description
            FeatureDescription.isEditable = false
        }
    }
}
