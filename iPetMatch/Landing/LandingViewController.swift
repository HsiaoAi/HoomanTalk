//
//  LandingViewControViewController.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 14/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

class LandingViewController: UIViewController {

    @IBOutlet weak var loginView: UIView!

    @IBOutlet weak var signupView: UIView!

    @IBOutlet weak var loginButton: LGButton!

    @IBOutlet weak var signupButton: LGButton!
    override func viewDidLoad() {

        super.viewDidLoad()

        setup()

    }

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)

    }

    func setup() {

        loginView.isHidden = false

        signupView.isHidden = true

        self.view.bringSubview(toFront: loginView)

        self.view.bringSubview(toFront: loginButton)

        loginButton.titleColor = UIColor.Custom.greyishBrown

        signupButton.titleColor = .white

    }

    @IBAction func touchLoginButton(_ sender: LGButton) {

        loginView.isHidden = false

        signupView.isHidden = true

        sender.titleColor = UIColor.Custom.greyishBrown

        signupButton.titleColor = .white

        self.view.bringSubview(toFront: loginView)

        self.view.bringSubview(toFront: sender)

    }

    @IBAction func tapSignupButton(_ sender: LGButton) {

        signupView.isHidden = false

        loginView.isHidden = true

        sender.titleColor = UIColor.Custom.greyishBrown

        loginButton.titleColor = .white

        self.view.bringSubview(toFront: signupView)

        self.view.bringSubview(toFront: sender)
    }

    @IBAction func tapLogOut(_ sender: Any) {

        QBRequest.logOut(successBlock: nil, errorBlock: nil)

    }

}
