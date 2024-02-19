//
//  DocumentTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 19.02.2024.
//

import UIKit

class DocumentTableViewCell: UITableViewCell {

    static let identifier = "DocumentTableViewCell"
    
    @IBOutlet var DocumentIcon: SpringImageView!
    @IBOutlet var DocumentTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(document: DocumentModel) {
        DocumentIcon.image = UIImage(named: getIcon(format: document.format))
        DocumentIcon.tintColor = getColorForIcon(format: document.format)
        DocumentTitle.text = document.name
    }
    
    private func getIcon(format: String)-> String {
        if format == "pdf" {
            return "pdf"
        } else if format.contains("doc") {
            return "word"
        }
        return ""
    }
    
    private func getColorForIcon(format: String)-> UIColor {
        if format == "pdf" {
            return .systemRed
        } else if format.contains("doc") {
            return .systemBlue
        }
        return .label
    }
}
