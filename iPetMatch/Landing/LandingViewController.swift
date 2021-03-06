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
        SCLAlertView().dismiss(animated: true, completion: nil)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    func setup() {

        loginView.isHidden = false
        signupView.isHidden = true
        self.view.bringSubview(toFront: loginView)
        self.view.bringSubview(toFront: loginButton)
        loginButton.titleColor = .white
        signupButton.titleColor = .white
        loginButton.titleString = NSLocalizedString("Log in", comment: "")
        signupButton.titleString = NSLocalizedString("Sign up", comment: "")

    }

    @IBAction func touchLoginButton(_ sender: LGButton) {

        loginView.isHidden = false

        signupView.isHidden = true

        self.view.bringSubview(toFront: loginView)

        self.view.bringSubview(toFront: loginButton)

    }

    @IBAction func tapSignupButton(_ sender: LGButton) {

        signupView.isHidden = false

        loginView.isHidden = true

        self.view.bringSubview(toFront: signupView)

        self.view.bringSubview(toFront: sender)
    }

}

extension LandingViewController {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
