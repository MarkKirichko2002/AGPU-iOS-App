//
//  ContactsTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 29.07.2023.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {
    
    static let identifier = "ContactsTableViewCell"
    
    @IBOutlet var ContactName: UILabel!
    @IBOutlet var ContactInfo: UILabel!
    @IBOutlet var ContactPhoneNumber: UILabel!
    
    func configure(contact: ContactsModel) {
        ContactName.text = contact.name
        ContactInfo.text = contact.degree
        ContactPhoneNumber.text = contact.phoneNumber
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ContactName.textColor = .label
        ContactInfo.textColor = .label
        ContactPhoneNumber.textColor = .label
        backgroundColor = .systemBackground
    }
}
