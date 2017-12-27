//
//  MatchViewController.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 27/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

class MatchViewController: UIViewController {

    @IBOutlet weak var kolodaView: KolodaView!

    var matchUsers = [MatchUser]()

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

        FetchUsersManager.instance.delegate = self

        FetchUsersManager.instance.query()

    }

}

extension MatchViewController: FetchUsersManagerProtocol {

    func didFetchUsers(_ fetchUsers: [MatchUser]) {

        self.matchUsers = fetchUsers

        DispatchQueue.main.async {

            self.kolodaView.reloadData()

        }

    }

    func didFetchUsersError(_ fetchUserError: Error) {

    }

}

extension MatchViewController: KolodaViewDelegate {

    func setupKolodaView() {

        kolodaView.dataSource = self

        kolodaView.delegate = self

        kolodaView.alphaValueSemiTransparent = 0.1

        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal

    }

   // @objc func

    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {

        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )

        let alertView = SCLAlertView(appearance: appearance)

        alertView.addButton(NSLocalizedString("Yes", comment: "")) {

            self.kolodaView.resetCurrentCardIndex()

        }

        alertView.addButton(NSLocalizedString("No", comment: "")) {

            SCLAlertView().showInfo(
                NSLocalizedString("Information", comment: ""),
                subTitle: NSLocalizedString("Tip: Change setting to explore more cards", comment: "")
            )

            return

        }

        alertView.showInfo(NSLocalizedString("Information", comment: ""),

                             subTitle: NSLocalizedString("Run out of cards, want to reload cards?", comment: ""))

    }

    // DidselectCardAt: 看詳細資料

    func kolodaShouldApplyAppearAnimation(_ koloda: KolodaView) -> Bool {
        return true
    }

}

extension MatchViewController: KolodaViewDataSource {

    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {

        return self.matchUsers.count

    }

    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {

        return .default

    }

    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {

        guard let matchCardView = Bundle.main.loadNibNamed("MatchCardView", owner: self, options: nil)?.first as? MatchCardView else {

            return UIView()
        }

        if self.matchUsers.count > index {

            let matchUser = self.matchUsers[index]

            matchCardView.userInfo.text = "\(matchUser.name), \(todayYear - matchUser.yearOfBirth)"
            
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

    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {

        return Bundle.main.loadNibNamed("MatchOverlayView", owner: self, options: nil)?[0] as? OverlayView
    }

}
