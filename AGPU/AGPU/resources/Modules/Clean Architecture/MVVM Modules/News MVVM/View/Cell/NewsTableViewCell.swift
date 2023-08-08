//
//  NewsTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 08.08.2023.
//

import UIKit
import SDWebImage

class NewsTableViewCell: UITableViewCell {
    
    static let identifier = "NewsTableViewCell"
    
    @IBOutlet var NewsImage: SpringRoundedImageView!
    @IBOutlet var NewsTitle: UILabel!
    @IBOutlet var NewsDate: UILabel!
    
    func configure(news: NewsModel) {
        NewsImage.sd_setImage(with: URL(string: news.previewImage ?? ""))
        NewsTitle.text = news.title
        NewsDate.text = news.date
    }
}
