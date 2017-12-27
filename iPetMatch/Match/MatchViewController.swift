//
//  MatchViewController.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 27/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

class MatchViewController: UIViewController {

    @IBOutlet weak var kolodaView: KolodaView!

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

        kolodaView.resetCurrentCardIndex()

    }

    // DidselectCardAt: 看詳細資料
    
    func kolodaShouldApplyAppearAnimation(_ koloda: KolodaView) -> Bool {
        return true
    }
    
}

extension MatchViewController: KolodaViewDataSource {

    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {

        return 5

    }

    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {

        return .default

    }

    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {

        guard let matchCardView = Bundle.main.loadNibNamed("MatchCardView", owner: self, options: nil)?.first as? MatchCardView else {

            return UIView()
        }

        var colors: [UIColor] = [.yellow, .red, .blue, .black, .green]

        matchCardView.userImageView.backgroundColor = colors[index]

        return matchCardView

    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        
        return Bundle.main.loadNibNamed("MatchOverlayView", owner: self, options: nil)?[0] as? OverlayView
    }

}
