//
//  AGPUSubSectionTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 09.06.2023.
//

import UIKit

class AGPUSubSectionTableViewCell: UITableViewCell {
    
    static let identifier = "AGPUSubSectionTableViewCell"
    
    private let AGPUSubSectionTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(AGPUSubSectionTitle)
        makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            AGPUSubSectionTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            AGPUSubSectionTitle.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 30),
            AGPUSubSectionTitle.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -30),
            AGPUSubSectionTitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
        ])
    }
    
    func configure(subsection: AGPUSubSectionModel) {
        AGPUSubSectionTitle.text = subsection.name
    }
}
