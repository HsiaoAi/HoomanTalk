//
//  MatchViewController.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 27/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

class MatchViewController: UIViewController {

    @IBOutlet weak var kolodaView: KolodaView!

    var matchCardUsers = [MatchCardUser]()
    
    var likedMeUsers = [MatchCardUser]()

    var todayYear: Int {

        let todayDate: Date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let todayYesrString = dateFormatter.string(from: todayDate)
        return Int(todayYesrString)!

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

        setupKolodaView()

    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        
        MatchCardUsersManager.instance.observeMatchCardUsers()
        MatchCardUsersManager.instance.delegate = self
        
        LikedUsersManger.instance.delegate = self
        LikedUsersManger.instance.observeReceivedLikes()

    }

    override func viewDidDisappear(_ animated: Bool) {

        super.viewDidDisappear(animated)

        self.matchCardUsers = [MatchCardUser]()
        
    }

}

extension MatchViewController: MatchCardUsersManagerProtocol {
    func didObserveMatchCardUsers(_ matchCardUsers: [MatchCardUser]) {
        
        self.matchCardUsers = matchCardUsers
        
        MatchCardUsersManager.instance.matchCardUsers = [MatchCardUser]()
        
        DispatchQueue.main.async {
            
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

        print("here")

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

            matchCardView.likeButton.addTarget(self, action: #selector(tagLikeButton(_:)), for: .touchUpInside)

            matchCardView.userInfo.text = "\(matchUser.name), \(todayYear - matchUser.yearOfBirth)"

            matchCardView.userImageView.contentMode = .scaleToFill

            let imageAdress = matchUser.imageURL
            if let imageURL = URL(string: imageAdress!) {

                Nuke.loadImage(
                    with: imageURL,
                    into: matchCardView.userImageView
                )
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

        let index = self.kolodaView.currentCardIndex

        if let matchCardView = sender.superview as? MatchCardView {

            matchCardView.likeButtonBorderView.layer.borderColor = UIColor.Custom.lightishRed.cgColor
            matchCardView.likeButtonBorderView.layer.borderWidth = 2

        }

        Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false, block: { _ in

            self.kolodaView.swipe(.right)

        })
        let likeUser = self.matchCardUsers[index]

        LikedUsersManger.instance.didLikeUser(with: likeUser)

    }

}

extension MatchViewController: LikedUsersMangerProtocol {
    func didObserveReceivedLikes(_ likedMeUsers: [LikeMe]) {
        print("+++++++++++", likedMeUsers)
        
        
    }
    
    
    func observeReceivedLikesError(_ error: Error) {
        
    }
    
    
    
    
}
