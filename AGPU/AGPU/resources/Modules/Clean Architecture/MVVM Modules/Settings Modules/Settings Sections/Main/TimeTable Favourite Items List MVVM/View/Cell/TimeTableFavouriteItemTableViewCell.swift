//
//  TimeTableFavouriteItemTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 27.04.2024.
//

import UIKit
import SnapKit

protocol ITimeTableFavouriteItemTableViewCell: AnyObject {
    func itemWasSelected(item: SearchTimetableModel)
}

class TimeTableFavouriteItemTableViewCell: UITableViewCell {
    
    static let identifier = "TimeTableFavouriteItemTableViewCell"
    
    weak var delegate: ITimeTableFavouriteItemTableViewCell?
    
    var item: SearchTimetableModel?
    
    let itemName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .black)
        return label
    }()
    
    let infoButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(named: "info"), for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        tintColor = .systemGreen
        contentView.addSubviews(itemName, infoButton)
        infoButton.addTarget(self, action: #selector(showInfo), for: .touchUpInside)
        makeConstraints()
    }
    
    private func makeConstraints() {
        
        itemName.snp.makeConstraints { maker in
            maker.left.equalToSuperview().inset(20)
            maker.top.equalToSuperview().inset(10)
            maker.bottom.equalToSuperview().inset(10)
        }
        
        infoButton.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(10)
            maker.right.equalToSuperview().inset(10)
            maker.bottom.equalToSuperview().inset(10)
        }
    }
    
    func configure(item: SearchTimetableModel) {
        itemName.text = item.name
        self.item = item
    }
    
    @objc private func showInfo() {
        guard let item = item else {return}
        HapticsManager.shared.hapticFeedback()
        delegate?.itemWasSelected(item: item)
    }
}
