//
//  SplashScreenTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 03.04.2024.
//

import UIKit
import SnapKit

protocol ISplashScreenTableViewCell: AnyObject {
    func infoWasTapped(video: String)
}

class SplashScreenTableViewCell: UITableViewCell {
    
    static let identifier = "SplashScreenTableViewCell"
    
    weak var delegate: ISplashScreenTableViewCell?
    
    var video: String = ""
    
    let splashScreenName: UILabel = {
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
        contentView.addSubviews(splashScreenName, infoButton)
        infoButton.addTarget(self, action: #selector(showInfo), for: .touchUpInside)
        makeConstraints()
    }
    
    private func makeConstraints() {
        
        splashScreenName.snp.makeConstraints { maker in
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
    
    func configure(screen: SplashScreenOptions, viewModel: SplashScreensListViewModel) {
        let index = SplashScreenOptions.allCases.firstIndex(of: screen)!
        let isSelected = viewModel.isCurrentSplashScreenOption(index: index)
        splashScreenName.text = isSelected ? "\(screen.rawValue) ✅" : screen.rawValue
        splashScreenName.textColor = isSelected ? .systemGreen : .label
        self.video = screen.video
    }
    
    @objc private func showInfo() {
        HapticsManager.shared.hapticFeedback()
        delegate?.infoWasTapped(video: video)
    }
}
