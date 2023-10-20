//
//  AppFeatureDetailViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 22.07.2023.
//

import UIKit

final class AppFeatureDetailViewController: UIViewController {
    
    var feature: AppFeatureModel!
    
    @IBOutlet var FeatureName: UILabel!
    @IBOutlet var FeatureDescription: UITextView!

    // MARK: - Init
    init(feature: AppFeatureModel) {
        self.feature = feature
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        FeatureName.text = feature.name
        FeatureDescription.text = feature.description
        FeatureDescription.isEditable = false
    }
    
    private func setUpNavigation() {
        let titleView = CustomTitleView(image: "info icon", title: "Фишка №\(feature.id)", frame: .zero)
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .label
        navigationItem.titleView = titleView
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func closeScreen() {
         dismiss(animated: true)
    }
}
