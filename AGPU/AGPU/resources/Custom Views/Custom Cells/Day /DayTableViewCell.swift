//
//  DayTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 04.03.2024.
//

import UIKit
import SnapKit

protocol IDayTableViewCell: AnyObject {
    func dateWasSelected(date: String)
}

class DayTableViewCell: UITableViewCell {
    
    static let identifier = "DayTableViewCell"
    
    weak var delegate: IDayTableViewCell?
    
    var date: String = ""
    
    let dayName: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
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
        contentView.addSubviews(dayName, infoButton)
        infoButton.addTarget(self, action: #selector(showInfo), for: .touchUpInside)
        makeConstraints()
    }
    
    private func makeConstraints() {
        
        dayName.snp.makeConstraints { maker in
            maker.left.equalToSuperview().inset(20)
            maker.right.equalTo(infoButton.snp.left).inset(-10)
            maker.top.equalToSuperview().inset(10)
            maker.bottom.equalToSuperview().inset(10)
        }
        
        infoButton.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(10)
            maker.right.equalToSuperview().inset(10)
            maker.bottom.equalToSuperview().inset(10)
        }
    }
    
    func configure(date: String, info: String, currentDate: String) {
        let formattedDate = date.components(separatedBy: " ").last!
        print("\(currentDate) \(date)")
        if currentDate == formattedDate {
            dayName.text = "\(date) \(info) ✅"
        } else {
            dayName.text = "\(date) \(info)"
        }
        self.date = date
    }
    
    @objc private func showInfo() {
        HapticsManager.shared.hapticFeedback()
        delegate?.dateWasSelected(date: date)
    }
}
