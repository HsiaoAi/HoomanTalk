//
//  ChatUsersListTableViewCell.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 14/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

import UIKit

class ChatUsersListTableViewCell: UITableViewCell, Identifiable {

    class var identifier: String { return String(describing: self) }

    @IBOutlet weak var userNameLabel: UILabel!

    @IBOutlet weak var userNumberLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        self.layer.borderColor = UIColor.blue.cgColor

        self.layer.borderWidth = selected ? 5 : 0
    }

}
