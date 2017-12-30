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
    
    let friendsProvider = FriendProvider()
    
    var myFriens = [IPetUser]()

    // MARK: Property
    
    private var callToUserID: UInt?

    private let components: [ChatListComponent] = [ .user, .buttons ]

    override func viewDidLoad() {

        super.viewDidLoad()

        SCLAlertView().dismiss(animated: true, completion: nil)

        QBRTCAudioSession.instance().initialize

        self.navigationItem.hidesBackButton = false

        setUp()
        
        friendsProvider.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        friendsProvider.observeMyFriends()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        myFriens = [IPetUser]()
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

   

}
// Fetch friends list
extension ChatListTableViewController: FriendsProviderProtocol {
    func didObserveMyFriends(_ provider: FriendProvider, _ friends: [IPetUser]) {
        self.myFriens = friends
        
        DispatchQueue.main.async {
            
            self.tableView.reloadData()
            
        }
    }
    
    
    
}
 // MARK: - Table view data source
extension ChatListTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return components.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch components[section] {
        
        case .user:
            return self.myFriens.count
       
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
            return 40.0

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

            let friend = self.myFriens[indexPath.row]
            cell.userNumberLabel.text = friend.name
            cell.userNameLabel.text = String(friend.callingID)
            return cell

        case .buttons:
            
            let identifier = ChatListButtonsTableViewCell.identifier
            guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? ChatListButtonsTableViewCell else { return UITableViewCell() }
            self.callToUserID = 38863883
            cell.audioButton.addTarget(self, action: #selector(startAudioCalling), for: .touchUpInside)
            cell.videoButton.addTarget(self, action: #selector(startVedioCalling), for: .touchUpInside)
            
            return cell

        }

    }
}

// Selector functions
extension ChatListTableViewController {

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

