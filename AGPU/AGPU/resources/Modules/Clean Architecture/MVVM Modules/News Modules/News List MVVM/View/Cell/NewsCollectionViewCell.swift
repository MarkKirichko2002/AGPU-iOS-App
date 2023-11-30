//
//  NewsCollectionViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 12.08.2023.
//

import UIKit
import SDWebImage

final class NewsCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "NewsCollectionViewCell"
    
    // MARK: - сервисы
    private let animation = AnimationClass()
    
    // MARK: - UI
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let NewsTitle: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 3
        label.font = .systemFont(ofSize: 15, weight: .black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
        contentView.addSubviews(imageView, NewsTitle, dateLabel)
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
            
            // Изображение новости
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            
            // Название новости
            NewsTitle.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            NewsTitle.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 7),
            NewsTitle.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -7),

            // Дата
            dateLabel.topAnchor.constraint(equalTo: NewsTitle.bottomAnchor, constant: 4),
            dateLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 7),
            dateLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -7),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setUpLayer()
    }
    
    public func configure(with news: Article) {
        DispatchQueue.main.async {
            self.imageView.sd_setImage(with: URL(string: news.previewImage))
            self.NewsTitle.text = news.title
            self.dateLabel.text = news.date
        }
    }
    
    func didTapCell(indexPath: IndexPath) {
        animation.flipAnimation(view: self)
        HapticsManager.shared.hapticFeedback()
    }
}
