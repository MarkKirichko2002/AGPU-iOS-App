//
//  ZoomImageViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 27.06.2024.
//

import UIKit
import SnapKit
import SDWebImage

final class ZoomImageViewController: UIViewController {
    
    let scrollView = UIScrollView()
    let imageView = UIImageView()
    
    var isURL = false
    var url: String = ""
    
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
        
        if isURL {
            guard let url = URL(string: url) else {return}
            imageView.sd_setImage(with: url)
        }
        
        scrollView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = scrollView.bounds
        
        setUpLongGesture()
    }
    
    private func setUpLongGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(showAR))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(gesture)
    }
    
    @objc private func showAR() {
        let vc = ARViewController()
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        self.makeImage { image in
            vc.image = image
            DispatchQueue.main.async {
                self.present(navVC, animated: true)
            }
        }
    }
    
    private func makeImage(completion: @escaping(UIImage)->Void) {
        guard let url = URL(string: url) else {return}
        URLSession.shared.dataTask(with: url) { data, error, _ in
            guard let data = data else {return}
            if let image = UIImage(data: data) {
                HapticsManager.shared.hapticFeedback()
                completion(image)
            }
        }.resume()
    }
}

// MARK: - UIScrollViewDelegate
extension ZoomImageViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
