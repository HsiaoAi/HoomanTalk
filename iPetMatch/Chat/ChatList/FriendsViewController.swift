//
//  FriendsViewController.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 31/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController {
    
        
    enum ChatListComponent {
        case user, buttons
    }
    
    let friendsProvider = FriendProvider()
    var myFriends = [Friend]()
    var filterFriends = [Friend]()
    var shouldShowSearchResults = false
    let searchBar = UISearchBar()
    
    
    
    // MARK: Property
    
    private var callToUserID: UInt?
    
    private let components: [ChatListComponent] = [ .user, .buttons ]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        SCLAlertView().dismiss(animated: true, completion: nil)
        
        QBRTCAudioSession.instance().initialize
        
        self.navigationItem.hidesBackButton = false
        
        setUpTableView()
        setupSearchBar()
        
        friendsProvider.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        friendsProvider.observeMyFriends()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func setupSearchBar() {
        
        searchBar.searchBarStyle = .prominent
        searchBar.placeholder = NSLocalizedString("Search Friend", comment: "")
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        searchBar.resignFirstResponder()
        navigationItem.titleView = searchBar
        
    }
    
    private func setUpTableView() {
        
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.alwaysBounceVertical = false
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 100))
        footerView.backgroundColor = .red
        tableView.tableFooterView = footerView
        
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
    func didObserveMyFriends(_ provider: FriendProvider, _ friends: [Friend]) {
        
        self.myFriends = friends
        
        print(self.myFriends = friends)
        
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
        
        switch components[section] {
            
        case .user:
            let friendsWillShow = shouldShowSearchResults ? self.filterFriends : self.myFriends
            return friendsWillShow.count
            
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
            
            return (tableView.bounds.height - 64 ) / 6
            
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
            
            
            let friendsWillShow = shouldShowSearchResults ? self.filterFriends : self.myFriends
            
            let friend = friendsWillShow[indexPath.row]
            cell.userNameLabel.text = friend.name
            cell.lastCallLabel.text = String(describing: friend.lastCallTime)
            
            let imageAdress = friend.imageURL
            if let imageURL = URL(string: imageAdress!) {
                
                UserManager.setUserProfileImage(with: imageURL, into: cell.userImageLabel, activityIndicatorView: cell.loadingImageView)
                
            }
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let friendsWillShow = shouldShowSearchResults ? self.filterFriends : self.myFriends
        
        
        print(friendsWillShow[indexPath.row].callingID)
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

extension ChatListTableViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        doSearch()
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.text = ""
        searchBar.showsCancelButton = false
        self.shouldShowSearchResults = false
        self.searchBar.endEditing(true)
        self.tableView.reloadData()
        filterFriends = [Friend]()
        
    }
    
    func doSearch() {
        
        filterFriends = [Friend]()
        let searchName = searchBar.text!
        
        for friend in self.myFriends {
            
            if let friendName = friend.name,
                friendName.capitalized.components(separatedBy: " ").contains(searchName) {
                self.filterFriends.append(friend)
                print(self.filterFriends)
            }
        }
        
        self.shouldShowSearchResults = true
        self.tableView.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.searchBar.endEditing(true)
    }
    
    
    
}

