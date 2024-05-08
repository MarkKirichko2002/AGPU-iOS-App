//
//  ImageDetailViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 09.05.2024.
//

import UIKit

class ImageDetailViewController: UIViewController {

    var image: ImageModel?
    
    // MARK: - UI
    private var closeButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(named: "cross"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var shareButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(named: "share"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let currentImage: UIImageView = {
        let image = UIImageView()
        image.isUserInteractionEnabled = true
        image.backgroundColor = .label
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Загрузка..."
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    init(image: ImageModel) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpConstraints()
    }
    
    private func setUpView() {
        view.backgroundColor = .systemBackground
        view.addSubviews(closeButton, shareButton, currentImage, dateLabel)
        setUpImage()
        setUpTitle()
        closeButton.addTarget(self, action: #selector(closeScreen), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(share), for: .touchUpInside)
    }
    
    private func setUpImage() {
        guard let data = image else {return}
        guard let image = UIImage(data: data.image) else {return}
        currentImage.image = image
        setUpTap()
        setUpPinchZoom()
    }
    
    private func setUpTitle() {
        dateLabel.text = image?.date
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        dismiss(animated: true)
    }
    
    @objc private func share() {
        guard let data = image else {return}
        guard let image = UIImage(data: data.image) else {return}
        self.ShareImage(image: image, title: "Изображение", text: data.date)
        HapticsManager.shared.hapticFeedback()
    }
    
    private func setUpTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(transformToStandard))
        currentImage.addGestureRecognizer(tap)
    }
    
    private func setUpPinchZoom() {
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinch(_:)))
        currentImage.addGestureRecognizer(pinch)
    }
    
    @objc func pinch(_ gesture: UIPinchGestureRecognizer) {
        if gesture.state == .changed {
            let scale = gesture.scale
            if scale < 1.3 && scale > 0.9 {
                UIView.animate(withDuration: 0.5) {
                    self.currentImage.transform = CGAffineTransform(scaleX: scale, y: scale)
                }
            }
        }
    }
    
    @objc func transformToStandard() {
        UIView.animate(withDuration: 0.5) {
            self.currentImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    private func setUpConstraints() {
        
        shareButton.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(60)
            maker.right.equalToSuperview().inset(20)
        }
        
        closeButton.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(60)
            maker.left.equalToSuperview().inset(20)
        }
        
        currentImage.snp.makeConstraints { maker in
            maker.top.equalTo(shareButton.snp.bottom).offset(20)
            maker.centerX.equalToSuperview()
            maker.width.equalTo(250)
            maker.height.equalTo(250)
        }
        
        dateLabel.snp.makeConstraints { maker in
            maker.top.equalTo(currentImage.snp.bottom).offset(60)
            maker.centerX.equalToSuperview()
        }
    }
}
