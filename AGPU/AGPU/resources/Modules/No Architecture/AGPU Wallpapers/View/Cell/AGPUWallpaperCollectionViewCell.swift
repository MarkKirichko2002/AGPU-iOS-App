//
//  AGPUWallpaperCollectionViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 13.07.2023.
//

import UIKit

final class AGPUWallpaperCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "AGPUWallpaperCollectionViewCell"
    
    let imageView: UIImageView = {
       let imageView = UIImageView()
       imageView.contentMode = .scaleAspectFill
       imageView.clipsToBounds = true
       imageView.translatesAutoresizingMaskIntoConstraints = false
       return imageView
    }()
    
    // MARK: - Init
    override init(
        frame: CGRect
    ) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(imageView)
        addConstaints()
        setUpLayer()
    }
    
    required init(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func setUpLayer() {
        contentView.layer.cornerRadius = 8
        contentView.layer.shadowColor = UIColor.label.cgColor
    }
    
    private func addConstaints() {
        NSLayoutConstraint.activate([
            // изображение категории
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setUpLayer()
    }
    
    public func configure(with image: String) {
        imageView.image = UIImage(named: image)
    }
}
