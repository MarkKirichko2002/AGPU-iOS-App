//
//  NewsTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 13.05.2024.
//

import UIKit
import SnapKit
import SDWebImage

final class NewsTableViewCell: UITableViewCell {
    
    static let identifier = "NewsTableViewCell"
    
    // MARK: - сервисы
    private let animation = AnimationClass()
    private let dateManager = DateManager()
    
    private let newsImage: SpringImageView = {
        let image = SpringImageView()
        image.isInteraction = false
        image.tintColor = .label
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private let articleTitle: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 4
        label.font = .systemFont(ofSize: 14, weight: .black)
        return label
    }()
    
    private let articleDate: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 15, weight: .medium)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsImage.layer.borderWidth = 0
        newsImage.layer.borderColor = nil
        newsImage.image = nil
        articleTitle.text = nil
    }
    
    private func setUpView() {
        contentView.addSubviews(newsImage, articleTitle, articleDate)
        makeConstraints()
        setUpImage()
    }
    
    private func setUpImage() {
        newsImage.clipsToBounds = true
        newsImage.layer.cornerRadius = 10
        newsImage.isInteraction = true
    }
    
    private func makeConstraints() {
        newsImage.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(10)
            maker.left.equalToSuperview().inset(20)
            maker.bottom.equalToSuperview().inset(10)
            maker.width.equalTo(120)
            maker.height.equalTo(120)
        }
        articleTitle.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(10)
            maker.left.equalTo(newsImage.snp.right).offset(15)
            maker.right.equalToSuperview().inset(15)
            maker.bottom.equalToSuperview().inset(15)
        }
        articleDate.snp.makeConstraints { maker in
            maker.top.equalTo(articleTitle.snp.bottom).offset(-10)
            maker.left.equalTo(newsImage.snp.right).offset(15)
            maker.right.equalToSuperview().inset(15)
            maker.bottom.equalToSuperview().inset(10)
        }
    }
    
    func configure(article: Article) {
        
        let isStroke = UserDefaults.standard.object(forKey: "onBorderForDailyNews") as? Bool ?? true
        
        if isStroke {
            setStroke(for: article)
        } else {
            DispatchQueue.main.async {
                self.newsImage.sd_setImage(with: URL(string: article.previewImage))
                self.articleTitle.text = article.title
                self.articleDate.text = article.date
            }
        }
    }
    
    private func setStroke(for news: Article) {
        
        let date = dateManager.getCurrentDate()
        
        if news.date == date {
            newsImage.layer.borderWidth = 2
            newsImage.layer.borderColor = UIColor.label.cgColor
            DispatchQueue.main.async {
                self.newsImage.sd_setImage(with: URL(string: news.previewImage))
                self.articleTitle.text = news.title
                self.articleDate.text = "\(news.date) (сегодня!)"
            }
        } else {
            DispatchQueue.main.async {
                self.newsImage.sd_setImage(with: URL(string: news.previewImage))
                self.articleTitle.text = news.title
                self.articleDate.text = news.date
            }
        }
    }
    
    func didTapCell(indexPath: IndexPath) {
        animation.flipAnimation(view: self, option: .transitionFlipFromLeft) {
            HapticsManager.shared.hapticFeedback()
        }
    }
}
