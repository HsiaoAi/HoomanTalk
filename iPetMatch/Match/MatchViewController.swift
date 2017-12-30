//
//  MatchViewController.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 27/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

private let reuseIdentifier = "LikeMeCollectionViewCell"

class MatchViewController: UIViewController {

    @IBOutlet weak var kolodaView: KolodaView!

    var matchCardUsers = [IPetUser]()

    var likedMeUsers = [IPetUser]()

    var isSentLikeInCollectionView = false

    var usersIdLikedByCurrentUser = [String]()

    let matchCardsManager = MatchCardUsersManager()
    let likedMeManager = LikedUsersManger()

    @IBOutlet weak var likeMeCollectionView: UICollectionView!

    var todayYear: Int {

        let todayDate: Date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let todayYesrString = dateFormatter.string(from: todayDate)
        return Int(todayYesrString)!

    }

    @IBOutlet weak var likeMeButton: UIButton!

    @IBOutlet weak var browseButton: UIButton!

    @IBOutlet weak var hitHearToMatchLabel: UILabel!

    @IBAction func tapLikeMeButton(_ sender: Any) {

        likeMeButton.setTitleColor(UIColor.Custom.greyishBrown, for: .normal)

        browseButton.setTitleColor(.lightGray, for: .normal)

        likeMeCollectionView.isHidden = false

        view.bringSubview(toFront: likeMeCollectionView)

        kolodaView.isHidden = true

        hitHearToMatchLabel.isHidden = false

    }

    @IBAction func tapBrowse(_ sender: UIButton) {

        likeMeButton.setTitleColor(.lightGray, for: .normal)
        browseButton.setTitleColor(UIColor.Custom.greyishBrown, for: .normal)

        kolodaView.isHidden = false

        likeMeCollectionView.isHidden = true

        hitHearToMatchLabel.isHidden = true

    }

    @IBAction func logout(_ sender: Any) {

        do {

            try Auth.auth().signOut()

        } catch {

            SCLAlertView().showError(

                NSLocalizedString("Error", comment: ""),
                subTitle: NSLocalizedString("Something wrong, please try again", comment: "")
            )

            print(error)
        }
        QBRequest.logOut(successBlock: { _ in

            AppDelegate.shared.enterLandingView()

        }, errorBlock: nil)

    }

    override func viewDidLoad() {

        super.viewDidLoad()

        kolodaView.isHidden = true
        likeMeCollectionView.isHidden = true

        hitHearToMatchLabel.isHidden = true
        setupKolodaView()

        SVProgressHUD.dismiss()

        setupLikeMeCollectionView()

    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        SVProgressHUD.show(withStatus: NSLocalizedString("Browsing", comment: ""))

        // ResetView
        kolodaView.isHidden = true

        likeMeCollectionView.isHidden = true
        hitHearToMatchLabel.isHidden = true
        likeMeButton.setTitleColor(.lightGray, for: .normal)
        browseButton.setTitleColor(UIColor.Custom.greyishBrown, for: .normal)

        matchCardsManager.observeMatchCardUsers()
        matchCardsManager.observeLikesSentByCurrentUser()
        matchCardsManager.delegate = self

        likedMeManager.delegate = self
        likedMeManager.observeReceivedLikes()

    }

    override func viewDidDisappear(_ animated: Bool) {

        super.viewDidDisappear(animated)

        self.matchCardUsers = [IPetUser]()
        self.likedMeUsers = [IPetUser]()

        self.kolodaView.isHidden = true

    }

}

extension MatchViewController: MatchCardUsersManagerProtocol {
    func didobserveLikesSentByCurrentUser(manager: MatchCardUsersManager, usersIdLikedByCurrentUser: [String]) {

        self.usersIdLikedByCurrentUser = usersIdLikedByCurrentUser
        DispatchQueue.main.async {
            if self.isSentLikeInCollectionView {

                self.kolodaView.reloadData()

            }

            self.likeMeCollectionView.reloadData()
        }
    }

    func didObserveMatchCardUsers(_ matchCardUsers: [IPetUser]) {

        self.matchCardUsers = matchCardUsers

        self.matchCardsManager.matchCardUsers = [IPetUser]()

        DispatchQueue.main.async {

            self.kolodaView.isHidden = false

            SVProgressHUD.dismiss()

            self.kolodaView.reloadData()

        }
    }

    func observeMatchCardUsersError(_ error: Error) {

    }

}

extension MatchViewController: KolodaViewDelegate {

    func setupKolodaView() {

        kolodaView.dataSource = self

        kolodaView.delegate = self

        kolodaView.alphaValueSemiTransparent = 0.1
        kolodaView.countOfVisibleCards = 3

        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal

    }

    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {

        SCLAlertView().showInfo(
            NSLocalizedString("Run out of cards", comment: ""),
            subTitle: NSLocalizedString("Tip: Change setting to explore more cards", comment: "")
        )

        self.kolodaView.resetCurrentCardIndex()

    }

    // ToDo: version 1.1
    // DidselectCardAt: 看詳細資料
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {

    }

    func kolodaShouldApplyAppearAnimation(_ koloda: KolodaView) -> Bool {
        return true
    }

}

extension MatchViewController: KolodaViewDataSource {

    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {

        return self.matchCardUsers.count

    }

    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {

        return .default

    }

    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {

        guard let matchCardView = Bundle.main.loadNibNamed("MatchCardView", owner: self, options: nil)?.first as? MatchCardView else {

            return UIView()
        }

        if self.matchCardUsers.count > index {

            let matchUser = self.matchCardUsers[index]

            if self.usersIdLikedByCurrentUser.contains(matchUser.id) {

                matchCardView.likeButton.setClicked(true, animated: false)
                matchCardView.likeButton.isEnabled = false
            } else {

                matchCardView.likeButton.addTarget(self, action: #selector(tagLikeButton(_:)), for: .touchUpInside)

            }

            matchCardView.userInfo.text = "\(matchUser.name), \(todayYear - matchUser.yearOfBirth)"

            matchCardView.userImageView.contentMode = .scaleToFill

            let imageAdress = matchUser.imageURL
            if let imageURL = URL(string: imageAdress!) {

                UserManager.setUserProfileImage(with: imageURL, into: matchCardView.userImageView, activityIndicatorView: matchCardView.activityIndicatorView)
            }

        }

            return matchCardView

    }

    // ToDo: version 1.1

//    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
//
//        return Bundle.main.loadNibNamed("MatchOverlayView", owner: self, options: nil)?[0] as? OverlayView
//    }

}

// Selector functions
extension MatchViewController {

    @objc func tagLikeButton(_ sender: WCLShineButton) {

        isSentLikeInCollectionView = false

        let index = self.kolodaView.currentCardIndex

        if let matchCardView = sender.superview as? MatchCardView {
            matchCardView.likeButtonBorderView.layer.borderColor = UIColor.Custom.lightishRed.cgColor
            matchCardView.likeButtonBorderView.layer.borderWidth = 2
        }

        Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false, block: { _ in
            self.kolodaView.swipe(.right)
        })
        let likeUser = self.matchCardUsers[index]
        isSentLikeInCollectionView = false
        self.likedMeManager.sendLike(to: likeUser)

        if self.likedMeUsers.contains(likeUser),
            let currentUser = UserManager.instance.currentUser {
            let uid = currentUser.id
            let myFriendsRef = Database.database().reference().child("user-friends").child(uid).child(likeUser.id)
            let matchFriendInfo: [String: Any] = [IPetUser.Schema.name: likeUser.name,
                                             IPetUser.Schema.imageURL: likeUser.imageURL,
                                             IPetUser.Schema.callingID: likeUser.callingID,
                                             IPetUser.Schema.gender: likeUser.gender.rawValue,
                                             IPetUser.Schema.yearOfBirth: likeUser.yearOfBirth,
                                             IPetUser.Schema.petPersonType: likeUser.petPersonType.rawValue]
            myFriendsRef.updateChildValues(matchFriendInfo)

            let matchUserFriendsRef = Database.database().reference().child("user-friends").child(likeUser.id).child(uid)
            let myInfo: [String: Any] = [IPetUser.Schema.name: currentUser.name,
                                             IPetUser.Schema.id: currentUser.id,
                                             IPetUser.Schema.imageURL: currentUser.imageURL,
                                             IPetUser.Schema.callingID: currentUser.callingID,
                                             IPetUser.Schema.gender: currentUser.gender.rawValue,
                                             IPetUser.Schema.yearOfBirth: currentUser.yearOfBirth,
                                             IPetUser.Schema.petPersonType: currentUser.petPersonType.rawValue]

            matchUserFriendsRef.updateChildValues(myInfo)
        }

    }

    @objc func responseLike(_ sender: WCLShineButton) {

        isSentLikeInCollectionView = true

        if let cell = sender.superview?.superview as? LikeMeCollectionViewCell,
            let indexPath = likeMeCollectionView.indexPath(for: cell) {
            let matchUser = self.likedMeUsers[indexPath.row]

            self.likedMeManager.sendLike(to: matchUser)
            sender.isEnabled = false
            if let userIndexInMatchCard = matchCardUsers.index(of: matchUser) {

                self.kolodaView.reloadCardsInIndexRange(userIndexInMatchCard..<userIndexInMatchCard + 1)
            }

            if let currentUser = UserManager.instance.currentUser {
                let uid = currentUser.id
                let myFriendsRef = Database.database().reference().child("user-friends").child(uid).child(matchUser.id)
                let matchFriendInfo: [String: Any] = [IPetUser.Schema.name: matchUser.name,
                                                      IPetUser.Schema.imageURL: matchUser.imageURL,
                                                      IPetUser.Schema.callingID: matchUser.callingID,
                                                      IPetUser.Schema.gender: matchUser.gender.rawValue,
                                                      IPetUser.Schema.yearOfBirth: matchUser.yearOfBirth,
                                                      IPetUser.Schema.petPersonType: matchUser.petPersonType.rawValue]
                myFriendsRef.updateChildValues(matchFriendInfo)

                let matchUserFriendsRef = Database.database().reference().child("user-friends").child(matchUser.id).child(uid)
                let myInfo: [String: Any] = [IPetUser.Schema.name: currentUser.name,
                                             IPetUser.Schema.imageURL: currentUser.imageURL,
                                             IPetUser.Schema.callingID: currentUser.callingID,
                                             IPetUser.Schema.gender: currentUser.gender.rawValue,
                                             IPetUser.Schema.yearOfBirth: currentUser.yearOfBirth,
                                             IPetUser.Schema.petPersonType: currentUser.petPersonType.rawValue]

                matchUserFriendsRef.updateChildValues(myInfo)
            }
        }
    }

}

extension MatchViewController: LikedUsersMangerProtocol {

    func didLikeUser() {
        DispatchQueue.main.async {

            self.kolodaView.reloadData()
            self.likeMeCollectionView.reloadData()
        }
    }

    func didObserveReceivedLikes(_ likedMeUsers: [IPetUser]) {

        self.likedMeUsers = likedMeUsers

        DispatchQueue.main.async {

            self.likeMeCollectionView.reloadData()

        }

    }

    func observeReceivedLikesError(_ error: Error) {

    }

}

extension MatchViewController: UICollectionViewDelegateFlowLayout {

    func setupLikeMeCollectionView() {

        self.likeMeCollectionView.delegate = self
        self.likeMeCollectionView.dataSource = self
        self.likeMeCollectionView.showsVerticalScrollIndicator = false
        self.likeMeCollectionView.backgroundColor = .white

        likeMeCollectionView.register(UINib(nibName: "LikeMeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "LikeMeCollectionViewCell")
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = (self.likeMeCollectionView.bounds.width - 15) / 2
        return CGSize(width: width, height: width)

    }

}

extension MatchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return self.likedMeUsers.count

    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

         guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? LikeMeCollectionViewCell else { return UICollectionViewCell() }

        if (likedMeUsers.count > indexPath.row) {

            let user = likedMeUsers[indexPath.row]

            if self.usersIdLikedByCurrentUser.contains(user.id) {

                cell.likeButton.setClicked(true, animated: false)
                cell.likeButton.isEnabled = false

            } else {

                cell.likeButton.addTarget(self, action: #selector(responseLike(_:)), for: .touchUpInside)

            }

            cell.userInfoLabel.text = "\(user.name), \(user.petPersonType.rawValue.capitalized) Person"

            cell.userImageView.contentMode = .scaleToFill
            let imageAdress = user.imageURL
            if let imageURL = URL(string: imageAdress!) {

                UserManager.setUserProfileImage(with: imageURL, into: cell.userImageView, activityIndicatorView: cell.activityIndicatorView)
            }

        }

        return cell

    }

}
