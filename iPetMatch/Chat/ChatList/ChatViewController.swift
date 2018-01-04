//
//  ChatViewController.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 31/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {

    enum ChatListComponent {
        case user, buttons
    }

    let friendsProvider = FriendProvider()
    var myFriends = [Friend]()
    var filterFriends = [Friend]()
    var shouldShowSearchResults = false
    let searchBar = UISearchBar()
    var isCellExpaned: Bool = false
    var didSelectIndexPath: IndexPath?
    var userInfo: [String: String]?
    var selectedFriend: Friend?
    private var callToUserID: UInt?

    @IBOutlet weak var tableView: UITableView!

    // MARK: Property

    override func viewDidLoad() {

        super.viewDidLoad()

        SCLAlertView().dismiss(animated: true, completion: nil)

        QBRTCAudioSession.instance().initialize

        self.navigationItem.hidesBackButton = false
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension

        setupSearchBar()
        setUpTableView()

        friendsProvider.delegate = self
        CallManager.shared.delegate = self

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.friendsProvider.observeMyFriends()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    func setupSearchBar() {

        tableView.dataSource = self
        tableView.delegate = self

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

        if let headerView = Bundle.main.loadNibNamed("ChatInfoView", owner: self, options: nil)?.first as? ChatInfoView {

            tableView.tableHeaderView = headerView

        }
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 65))
        tableView.keyboardDismissMode = .onDrag
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = footerView
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
extension ChatViewController: FriendsProviderProtocol {
    func didObserveMyFriends(_ provider: FriendProvider, _ friends: [Friend]) {

        self.myFriends = friends

        print(self.myFriends = friends)

        DispatchQueue.main.async {

            self.tableView.reloadData()

        }
    }

}
// MARK: - Table view data source
extension ChatViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

            let friendsWillShow = shouldShowSearchResults ? self.filterFriends : self.myFriends
            return friendsWillShow.count

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == self.didSelectIndexPath && isCellExpaned {

            return 165

        } else {

            return 100
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let identifier = ChatUsersListTableViewCell.identifier

        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? ChatUsersListTableViewCell else {
            print("LoadCellError")
            return UITableViewCell() }

        let friends = shouldShowSearchResults ? self.filterFriends : self.myFriends

        if friends.count > indexPath.row {

            let friend = friends[indexPath.row]
            cell.set(content: friend)
            cell.audioCallButton.addTarget(self, action: #selector(startAudioCalling), for: .touchUpInside)
            cell.videoCallButton.addTarget(self, action: #selector(startVedioCalling), for: .touchUpInside)

        }

        return cell

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath == didSelectIndexPath {
            isCellExpaned = false
            self.didSelectIndexPath = nil
        } else {
            isCellExpaned = true
            self.didSelectIndexPath = indexPath

        }

        let friend = shouldShowSearchResults ? self.filterFriends[indexPath.row] : self.myFriends[indexPath.row]
        self.selectedFriend = friend
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        self.callToUserID = friend.callingID

        guard let user = UserManager.instance.currentUser else {
            SCLAlertView().showError(NSLocalizedString("Error", comment: ""),
                                     subTitle: NSLocalizedString("Please login again", comment: ""))
            return
        }

        let userInfo: [String: String] = [IPetUser.Schema.name: user.name,
                                            IPetUser.Schema.imageURL: user.imageURL!,
                                            IPetUser.Schema.callingID: String(describing: user.callingID)]
        CallManager.shared.fromId = user.id
        CallManager.shared.toId = friend.id

        self.userInfo = userInfo
        CallManager.shared.userInfo = userInfo

        if QBChat.instance.isConnected == false {
            SVProgressHUD.show(withStatus: NSLocalizedString("Loading...", comment: ""))
            UIApplication.shared.beginIgnoringInteractionEvents()

            guard let user = Auth.auth().currentUser else {
                SVProgressHUD.dismiss()
                UIApplication.shared.endIgnoringInteractionEvents()
                SCLAlertView().showError(NSLocalizedString("Error", comment: ""),
                                         subTitle: NSLocalizedString("Something wrong, please log in again", comment: ""))
                AppDelegate.shared.enterLandingView()
                // ToDo: AddLogout!
                return
            }

            if let email = user.email {
                QBRequest.logIn(withUserEmail: email,
                                password: user.uid,
                                successBlock: { (_, QBuser) in
                                    QBChat.instance.connect(with: QBuser, completion: { _ in
                                        SVProgressHUD.dismiss()
                                        UIApplication.shared.endIgnoringInteractionEvents()
                                        self.friendsProvider.observeMyFriends()
                                    })},
                                errorBlock: {_ in
                                    SVProgressHUD.dismiss()
                                    SCLAlertView().showError(NSLocalizedString("Error", comment: ""),
                                                             subTitle: NSLocalizedString("Something wrong, please log in again", comment: ""))
                                    AppDelegate.shared.enterLandingView()
                })
            }
        }
    }
}

// Selector functions
extension ChatViewController {

    @objc func startAudioCalling() {

        self.isCellExpaned = false
        self.didSelectIndexPath = nil
        self.tableView.reloadData()

        guard let toUserID = self.callToUserID else { return }

        CallManager.shared.makeCall(to: toUserID, with: .audio)
        let makeAudioCallViewController = MakeAudioCallViewController()
        makeAudioCallViewController.selectedFriend = self.selectedFriend
        let navigationController = UINavigationController(rootViewController: makeAudioCallViewController)
        self.navigationController?.present(navigationController, animated: true, completion: nil)

    }

    @objc func startVedioCalling() {

        self.isCellExpaned = false
        self.didSelectIndexPath = nil
        self.tableView.reloadData()

        guard let toUserID = self.callToUserID else { return }
        CallManager.shared.makeCall(to: toUserID, with: .video)
        let makeVideoCallViewController = MakeVideoCallViewController()
        makeVideoCallViewController.selectedFriend = self.selectedFriend
        self.present(makeVideoCallViewController, animated: true, completion: nil)

    }
}

extension ChatViewController: UISearchBarDelegate {

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
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
        let searchName = searchBar.text!.capitalized

        for friend in self.myFriends {

            if let friendName = friend.name,
                friendName.capitalized.components(separatedBy: " ").contains(searchName) {
                self.filterFriends.append(friend)
            }
        }

        self.shouldShowSearchResults = true
        self.tableView.reloadData()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.searchBar.endEditing(true)
    }

}

extension ChatViewController: CallManagerProtocol {
    func didMakeCall(_ callManager: CallManager) {

        friendsProvider.observeMyFriends()

    }
}
