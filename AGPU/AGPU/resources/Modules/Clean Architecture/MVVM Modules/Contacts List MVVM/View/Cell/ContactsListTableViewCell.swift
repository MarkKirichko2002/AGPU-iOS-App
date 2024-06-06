//
//  ContactsListTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 05.06.2024.
//

import UIKit
import SnapKit

class ContactsListTableViewCell: UITableViewCell {
    
    static let identifier = "ContactsListTableViewCell"
    
    private let contactIcon: SpringImageView = {
        let image = SpringImageView()
        image.image = UIImage(named: "contacts icon")
        image.isInteraction = false
        image.tintColor = .label
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private let contactName: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .black)
        return label
    }()
    
    private let phoneNumber: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .black)
        return label
    }()
    
    private let stack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        contentView.addSubviews(contactIcon, contactName, phoneNumber, stack)
        makeConstraints()
    }
    
    private func makeConstraints() {
        stack.addArrangedSubview(contactName)
        stack.addArrangedSubview(phoneNumber)
        contactIcon.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(10)
            maker.left.equalToSuperview().inset(30)
            maker.bottom.equalToSuperview().inset(10)
            maker.width.equalTo(65)
            maker.height.equalTo(65)
        }
        stack.snp.makeConstraints { maker in
            maker.left.equalTo(contactIcon.snp.right).offset(20)
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview()
        }
    }
    
    func configure(contact: ContactModel) {
        contactName.text = contact.name
        phoneNumber.text = contact.number
    }
}
