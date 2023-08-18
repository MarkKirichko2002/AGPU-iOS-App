//
//  CustomTitleView.swift
//  AGPU
//
//  Created by Марк Киричко on 18.07.2023.
//

import UIKit

final class CustomTitleView: UIView {
    
    var image: String = ""
    var title: String = ""
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    init(
        image: String,
        title: String,
        frame: CGRect
    ) {
        super.init(frame: frame)
        self.image = image
        self.title = title
        addSubviews(imageView,label)
        SetUpView()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func SetUpView() {
        imageView.image = UIImage(named: image)
        label.text = title
    }
    
    private func makeConstraints() {
        
        NSLayoutConstraint.activate([
            
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 45),
            imageView.heightAnchor.constraint(equalToConstant: 45),
            
            label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 5),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
