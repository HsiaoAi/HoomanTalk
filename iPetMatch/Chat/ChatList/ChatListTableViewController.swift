//
//  ChatListTableViewController.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 14/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

import UIKit

class ChatListTableViewController: UITableViewController, QBRTCClientDelegate {

    enum ChatListComponent {

        case user, buttons

    }

    // MARK: Property

    private var callToUserID: UInt?

    private let components: [ChatListComponent] = [ .user, .buttons ]

    override func viewDidLoad() {

        super.viewDidLoad()

        self.navigationItem.hidesBackButton = false

        setUp()

    }

    private func setUp() {

        tableView.keyboardDismissMode = .onDrag

        tableView.separatorStyle = .none

        let usersListNib = UINib(
            nibName: "ChatUsersListTableViewCell",
            bundle: nil
        )

        tableView.register(
            usersListNib,
            forCellReuseIdentifier: ChatUsersListTableViewCell.identifier
        )

        let buttonsNib = UINib(
            nibName: "ChatListButtonsTableViewCell",
            bundle: nil
        )

        tableView.register(
            buttonsNib,
            forCellReuseIdentifier: ChatListButtonsTableViewCell.identifier
        )

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return components.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch components[section] {

        case .user:
            return 50

        case .buttons:
            return 1

        }

    }

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {

        return 44.0

    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch components[indexPath.section] {

        case .user:

            return 20.0

        case .buttons:

            return 40.0

        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let component = components[indexPath.section]

        switch component {

        case .user :

            let identifier = ChatUsersListTableViewCell.identifier

            guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? ChatUsersListTableViewCell else {

                print("LoadCellError")

                return UITableViewCell() }

            cell.userNumberLabel.text = "\(indexPath.row)"

            cell.userNameLabel.text = "UserID"

            cell.backgroundColor = .blue

            return cell

        case .buttons:

            let identifier = ChatListButtonsTableViewCell.identifier

            guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? ChatListButtonsTableViewCell else { return UITableViewCell() }

            cell.audioButton.backgroundColor = UIColor.blue

            self.callToUserID = 38863883

            cell.audioButton.addTarget(self, action: #selector(startAudioCalling), for: .touchUpInside)

            cell.videoButton.addTarget(self, action: #selector(startVedioCalling), for: .touchUpInside)

            return cell

        }

    }

    @objc func startAudioCalling() {

        guard let toUserID = self.callToUserID else { return }

        CallManager.shared.makeCall(to: toUserID, with: .audio)

        let makeAudioCallViewController = MakeAudioCallViewController()

        let navigationController = UINavigationController(rootViewController: makeAudioCallViewController)

        self.navigationController?.present(navigationController, animated: true, completion: nil)

    }

    @objc func startVedioCalling() {

        self.present(MakeVideoCallViewController(), animated: true, completion: nil)

    }

}
