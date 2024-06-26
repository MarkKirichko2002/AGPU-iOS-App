//
//  ImageDetailViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 09.05.2024.
//

import UIKit
import SnapKit

protocol ImageDetailViewControllerARDelegate: AnyObject {
    func ARWasSelected(image: UIImage)
}

class ImageDetailViewController: UIViewController {

    var image: ImageModel?
    
    weak var delegate: ImageDetailViewControllerARDelegate?
    
    var isOption = false
    
    // MARK: - UI
    private var closeButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(named: "cross"), for: .normal)
        return button
    }()
    
    private var shareButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(named: "share"), for: .normal)
        return button
    }()
    
    private let currentImage: UIImageView = {
        let image = UIImageView()
        image.isUserInteractionEnabled = true
        return image
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let selectARMode: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.setTitle("AR режим", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .black)
        button.setTitleColor(.white, for: .normal)
        return button
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUpImage()
        setUpTitle()
        closeButton.addTarget(self, action: #selector(closeScreen), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(share), for: .touchUpInside)
    }
    
    private func setUpView() {
        view.backgroundColor = .systemBackground
        view.addSubviews(closeButton, shareButton, currentImage, dateLabel, selectARMode)
        selectARMode.addTarget(self, action: #selector(showAR), for: .touchUpInside)
    }
    
    private func setUpImage() {
        guard let data = image else {return}
        guard let image = UIImage(data: data.image) else {return}
        currentImage.image = image
        setUpTap()
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
    
    @objc private func showAR() {
        guard let image = currentImage.image else {return}
        if isOption {
            delegate?.ARWasSelected(image: image)
            self.dismiss(animated: true)
        } else {
            showARVC(image: image)
        }
    }
    
    private func showARVC(image: UIImage) {
        let vc = ARViewController()
        vc.image = image
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
    
    private func setUpTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(openFullImage))
        currentImage.addGestureRecognizer(tap)
    }
    
    @objc func openFullImage() {
        let vc = ZoomImageViewController(image: currentImage.image ?? UIImage())
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
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
        
        selectARMode.snp.makeConstraints { maker in
            maker.top.equalTo(dateLabel.snp.bottom).offset(50)
            maker.centerX.equalToSuperview()
        }
    }
}
