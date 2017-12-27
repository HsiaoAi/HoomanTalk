//
//  MatchViewController.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 27/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

class MatchViewController: UIViewController {

    @IBOutlet weak var kolodaView: KolodaView!

    override func viewDidLoad() {

        super.viewDidLoad()

        setupKolodaView()

    }

}

extension MatchViewController: KolodaViewDelegate {

    func setupKolodaView() {

        kolodaView.dataSource = self

        kolodaView.delegate = self

        self.modalTransitionStyle = .coverVertical

    }

    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {

        koloda.reloadData()

    }

    // DidselectCardAt: 看詳細資料
}

extension MatchViewController: KolodaViewDataSource {

    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {

        return 5

    }

    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {

        return .fast

    }

    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {

        guard let matchCardView = Bundle.main.loadNibNamed("MatchCardView", owner: self, options: nil)?.first as? MatchCardView else {

            return UIView()
        }

        var colors: [UIColor] = [.yellow, .red, .blue, .black, .green]

        matchCardView.userImageView.backgroundColor = colors[index]

        return matchCardView

    }

}
