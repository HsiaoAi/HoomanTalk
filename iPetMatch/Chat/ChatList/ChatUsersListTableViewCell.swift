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

    @IBOutlet weak var loadingImageView: NVActivityIndicatorView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var lastCallLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var actionPanelView: UIView!

    @IBOutlet weak var audioCallButton: LGButton!
    @IBOutlet weak var videoCallButton: LGButton!
    @IBOutlet weak var blockUserButton: LGButton!
    @IBOutlet weak var reportUSerButton: LGButton!

    @IBOutlet weak var friendInfoView: UIView!
    var friendCallingId: UInt?
    var friendInfo: [String: String]?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func set(content friend: Friend) {

        self.userNameLabel.text = friend.name
        self.lastCallLabel.text = String(describing: friend.lastCallTime)

        userImageView.image = nil
        let imageAdress = friend.imageURL
        if let imageURL = URL(string: imageAdress!) {
            UserManager.setUserProfileImage(with: imageURL, into: self.userImageView, activityIndicatorView: self.loadingImageView)
        }

        if let lastCallType = friend.lastCallType,
            let lastCallTime = friend.lastCallTime {

            lastCallLabel.text = "\(lastCallType): \(lastCallTime)"

        } else {

            lastCallLabel.text = NSLocalizedString("Click to start your first call!", comment: "")
        }

        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero

    }

}
