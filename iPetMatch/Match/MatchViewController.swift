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
    @IBOutlet weak var likeMeCollectionView: UICollectionView!

    var matchCardUsers = [IPetUser]()
    var likedMeUsers = [IPetUser]()
    var isSentLikeInCollectionView = false
    var usersIdLikedByCurrentUser = [String]()
    let matchCardsManager = MatchCardUsersManager()
    let likedMeManager = LikedUsersManger()
    let loadignImagesManager = LoadingImagesManager()
    var isFirstTime: Bool = true

    var todayYear: Int {

        let todayDate: Date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let todayYesrString = dateFormatter.string(from: todayDate)
        return Int(todayYesrString)!

    }

    @IBOutlet weak var likeMeButton: UIButton!

    @IBOutlet weak var browseButton: UIButton!

    @IBOutlet weak var runOutofCardView: UIView!

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
        runOutofCardView.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        kolodaView.isHidden = true
        likeMeCollectionView.isHidden = true
        hitHearToMatchLabel.isHidden = true
        setupKolodaView()
        SVProgressHUD.show(withStatus: NSLocalizedString("Browsing", comment: ""))
        setupLikeMeCollectionView()
        matchCardsManager.observeMatchCardUsers()
        matchCardsManager.observeLikesSentByCurrentUser()
        matchCardsManager.delegate = self
        likedMeManager.delegate = self
        likedMeManager.observeReceivedLikes()
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        // ResetView
        kolodaView.isHidden = false
        runOutofCardView.isHidden = true
        likeMeCollectionView.isHidden = true
        hitHearToMatchLabel.isHidden = true
        likeMeButton.setTitleColor(.lightGray, for: .normal)
        browseButton.setTitleColor(UIColor.Custom.greyishBrown, for: .normal)

    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.runOutofCardView.isHidden = true
    }

}

extension MatchViewController: MatchCardUsersManagerProtocol {
    func didobserveLikesSentByCurrentUser(manager: MatchCardUsersManager, usersIdLikedByCurrentUser: [String]) {

        self.usersIdLikedByCurrentUser = usersIdLikedByCurrentUser
        DispatchQueue.main.async {
            if self.isSentLikeInCollectionView {

                self.kolodaView.reloadData()

            } else {
                self.likeMeCollectionView.reloadData()
            }

        }
    }

    func didObserveMatchCardUsers(_ matchCardUsers: [IPetUser]) {

        self.matchCardUsers = matchCardUsers
        self.matchCardsManager.matchCardUsers = [IPetUser]()

        DispatchQueue.main.async {

            SVProgressHUD.dismiss()

            self.kolodaView.reloadData()

            self.kolodaView.isHidden = false

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
        kolodaView.countOfVisibleCards = 4

        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal

    }

    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        runOutofCardView.isHidden = false
        self.view.bringSubview(toFront: runOutofCardView)
        self.kolodaView.resetCurrentCardIndex()

        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alertview = SCLAlertView(appearance: appearance)
        let buttonYes = NSLocalizedString("Yes", comment: "")
        let buttonNo = NSLocalizedString("No", comment: "")

        alertview.addButton(buttonYes) {

            self.runOutofCardView.isHidden = true
        }
        alertview.addButton(buttonNo) { }
        alertview.showNotice(NSLocalizedString("Notice", comment: ""),
                             subTitle: NSLocalizedString("Run out of cards\nDo you want to reload cards", comment: ""))
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

        return .fast

    }

    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {

        guard let matchCardView = Bundle.main.loadNibNamed("MatchCardView", owner: self, options: nil)?.first as? MatchCardView else {

            return UIView()
        }

        if self.matchCardUsers.count > index {

            let matchUser = self.matchCardUsers[index]
            var userPets = [Pet]()
            let petsRef = Database.database().reference().child("user-pets").child(matchUser.id)
            petsRef.observeSingleEvent(of: .value) { snapshot in

                if let petsDic = snapshot.value as? [String: Any] {
                    for (petId, petData) in petsDic {
                        guard let petDic = petData as? [String: Any] else { return }
                        let pet = Pet(dictionary: petDic)
                        userPets.append(pet)
                    }
                    matchCardView.setupPetsCollectionView(pets: userPets)
                }

                let imageUrl = matchUser.imageURL
                self.loadignImagesManager.downloadAndCacheImage(urlString: imageUrl!, imageView: matchCardView.userImageView, activityIndicatorView: matchCardView.activityIndicatorView, placeholderImage: nil)
                self.loadignImagesManager.downloadAndCacheImage(urlString: imageUrl!, imageView: matchCardView.backgroundUserImage, activityIndicatorView: matchCardView.activityIndicatorView, placeholderImage: nil)

                if self.usersIdLikedByCurrentUser.contains(matchUser.id) {
                    matchCardView.likeButton.setClicked(true, animated: false)
                    matchCardView.likeButton.isEnabled = false
                } else {

                    matchCardView.likeButton.addTarget(self, action: #selector(self.tagLikeButton(_:)), for: .touchUpInside)

                }
                let yearsOld = NSLocalizedString("yrs", comment: "")
                matchCardView.nameLabel.text = matchUser.name + ", \(self.todayYear - matchUser.yearOfBirth) " + yearsOld
                let im = NSLocalizedString("I'm", comment: "")
                matchCardView.genderLabel.text = (matchUser.gender == .male) ? im + "🙋🏻‍♂️" : im + "🙋🏻‍♀️"

                switch matchUser.petPersonType {
                case .dog:
                    matchCardView.petTypeLabel.text = "❤️🐶"

                case .cat:
                    matchCardView.petTypeLabel.text = "❤️🐱"

                case .both:
                    matchCardView.petTypeLabel.text = "❤️🐶🐱"

                }

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
            let matchFriendInfo: [String: Any] = [Friend.Schema.name: likeUser.name,
                                                  Friend.Schema.imageURL: likeUser.imageURL!,
                                                  Friend.Schema.callingID: likeUser.callingID,
                                                  Friend.Schema.gender: likeUser.gender.rawValue,
                                                  Friend.Schema.yearOfBirth: likeUser.yearOfBirth,
                                                  Friend.Schema.loginEmail: likeUser.loginEmail,
                                                  Friend.Schema.id: likeUser.id,
                                                  Friend.Schema.petPersonType: likeUser.petPersonType.rawValue]

            myFriendsRef.updateChildValues(matchFriendInfo)

            let matchUserFriendsRef = Database.database().reference().child("user-friends").child(likeUser.id).child(uid)
            let myInfo: [String: Any] = [Friend.Schema.name: currentUser.name,
                                         Friend.Schema.id: currentUser.id,
                                         Friend.Schema.imageURL: currentUser.imageURL,
                                         Friend.Schema.callingID: currentUser.callingID,
                                         Friend.Schema.gender: currentUser.gender.rawValue,
                                         Friend.Schema.yearOfBirth: currentUser.yearOfBirth,
                                         Friend.Schema.loginEmail: currentUser.loginEmail,
                                         Friend.Schema.petPersonType: currentUser.petPersonType.rawValue]

            matchUserFriendsRef.updateChildValues(myInfo)
        }

    }

    @objc func responseLike(_ sender: WCLShineButton) {

        isSentLikeInCollectionView = true

        if let cell = sender.superview?.superview as? LikeMeCollectionViewCell,
            let indexPath = likeMeCollectionView.indexPath(for: cell) {
            let matchUser = self.likedMeUsers[indexPath.row]
            self.likedMeManager.sendLike(to: matchUser)
            cell.likeButton.isEnabled = false
            if let userIndexInMatchCard = matchCardUsers.index(of: matchUser) {

                self.kolodaView.reloadCardsInIndexRange(userIndexInMatchCard..<userIndexInMatchCard + 1)
            }

            if let currentUser = UserManager.instance.currentUser {
                let uid = currentUser.id
                let myFriendsRef = Database.database().reference().child("user-friends").child(uid).child(matchUser.id)
                let matchFriendInfo: [String: Any] = [Friend.Schema.name: matchUser.name,
                                                      Friend.Schema.id: matchUser.id,
                                                      Friend.Schema.imageURL: matchUser.imageURL ?? "",
                                                      Friend.Schema.callingID: matchUser.callingID,
                                                      Friend.Schema.gender: matchUser.gender.rawValue,
                                                      Friend.Schema.yearOfBirth: matchUser.yearOfBirth,
                                                      Friend.Schema.loginEmail: matchUser.loginEmail,
                                                      Friend.Schema.petPersonType: matchUser.petPersonType.rawValue]
                myFriendsRef.updateChildValues(matchFriendInfo)

                let matchUserFriendsRef = Database.database().reference().child("user-friends").child(matchUser.id).child(uid)
                let myInfo: [String: Any] = [Friend.Schema.name: currentUser.name,
                                             Friend.Schema.id: currentUser.id,
                                             Friend.Schema.imageURL: currentUser.imageURL ?? "",
                                             Friend.Schema.callingID: currentUser.callingID,
                                             Friend.Schema.gender: currentUser.gender.rawValue,
                                             Friend.Schema.yearOfBirth: currentUser.yearOfBirth,
                                             Friend.Schema.loginEmail: currentUser.loginEmail,
                                             Friend.Schema.petPersonType: currentUser.petPersonType.rawValue]

                matchUserFriendsRef.updateChildValues(myInfo)

                pushNewFriendNotifictaion(user1Id: "\(matchUser.callingID)", user2Id: "\(currentUser.callingID)")
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

        if #available(iOS 10, *) {
            likeMeCollectionView.isPrefetchingEnabled = false
        }

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

        if likedMeUsers.count > indexPath.row {

            let user = likedMeUsers[indexPath.row]

            if self.usersIdLikedByCurrentUser.contains(user.id) {
                cell.likeButton.setClicked(true, animated: false)
                cell.likeButton.isEnabled = false

            } else {
                cell.likeButton.setClicked(false, animated: false)
                cell.likeButton.isEnabled = true
                cell.likeButton.addTarget(self, action: #selector(responseLike(_:)), for: .touchUpInside)
            }

            var petTypeString = ""
            switch user.petPersonType {
            case .dog:
                petTypeString = "❤️🐶"
            case .cat:
                petTypeString = "❤️🐱"
            case .both:
                petTypeString = "❤️🐶🐱"
            }

            cell.userInfoLabel.text = "\(user.name), \(petTypeString)"

            cell.userImageView.image = nil
            cell.userImageView.contentMode = .scaleToFill

            let imageAdress = user.imageURL
            self.loadignImagesManager.downloadAndCacheImage(urlString: imageAdress!, imageView: cell.userImageView, activityIndicatorView: cell.activityIndicatorView, placeholderImage: nil)

        }

        return cell

    }

}

extension MatchViewController {

    func pushNewFriendNotifictaion(user1Id: String, user2Id: String) {

        let pushMessage = NSLocalizedString("You got a new friend! Come back to check it.", comment: "")

        QBRequest.sendPush(withText: pushMessage,
                           toUsers: user1Id,
                           successBlock: nil,
                           errorBlock: nil
        )

        QBRequest.sendPush(withText: pushMessage,
                           toUsers: user2Id,

                           successBlock: nil,
                           errorBlock: nil
        )

    }
}
