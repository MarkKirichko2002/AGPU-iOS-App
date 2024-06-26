//
//  ZoomImageViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 27.06.2024.
//

import UIKit
import SnapKit

final class ZoomImageViewController: UIViewController {

    let scrollView = UIScrollView()
    let imageView = UIImageView()
    
    init(image: UIImage) {
        self.imageView.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpView()
        setUpScrollView()
        setUpImageView()
    }
    
    private func setUpNavigation() {
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .plain, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .label
        
        navigationItem.title = "Изображение"
        navigationItem.rightBarButtonItem = closeButton
        
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        dismiss(animated: true)
    }
    
    private func setUpView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setUpScrollView() {
        view.addSubview(scrollView)
        scrollView.frame = view.bounds
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
    }
    
    private func setUpImageView() {
        scrollView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = scrollView.bounds
    }
}

// MARK: - UIScrollViewDelegate
extension ZoomImageViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
