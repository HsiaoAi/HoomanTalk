//
//  ReportUserViewController.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 05/01/2018.
//  Copyright © 2018 Hsiao Ai LEE. All rights reserved.
//

import UIKit

class ReportUserViewController: UIViewController {

    @IBOutlet weak var textfieldView: UITextView!

    @IBOutlet weak var reportView: UIView!
    var selectUserId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupReportView()
        setupTextView()
        setupGesture()
    }

    func setupReportView() {
        reportView.layer.cornerRadius = 10.0
        reportView.clipsToBounds = true
    }

    @IBAction func sendReport(_ sender: UIButton) {

        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alertview = SCLAlertView(appearance: appearance)
        let buttonYes = NSLocalizedString("Yes", comment: "")
        let buttonNo = NSLocalizedString("No", comment: "")

        alertview.addButton(buttonYes) {
            let ref = Database.database().reference().child("reports").childByAutoId()
            let content = self.textfieldView.text!
            let value = [IPetUser.Schema.id: self.selectUserId!,
                         "about": content]
            ref.updateChildValues(value)

            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            let alertview = SCLAlertView(appearance: appearance)
            let buttonDone = NSLocalizedString("Done", comment: "")
            alertview.addButton(buttonDone) {

                self.dismiss(animated: true, completion: nil)
            }

            alertview.showSuccess(NSLocalizedString("Success", comment: ""), subTitle: NSLocalizedString("Sent this report", comment: ""))
        }

        alertview.addButton(buttonNo) {}
        alertview.showNotice(NSLocalizedString("Notice", comment: ""), subTitle: NSLocalizedString("Are you sure to send this report", comment: ""))
    }

    @IBAction func cancelReport(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}

extension ReportUserViewController: UITextViewDelegate {

    func setupTextView() {
        textfieldView.delegate = self
        let textViewPlaceholder = NSLocalizedString("What do you want to report about this user?", comment: "")
        textfieldView.text = textViewPlaceholder
        textfieldView.textColor = .lightGray
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = UIColor.Custom.greyishBrown
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            let textViewPlaceholder = NSLocalizedString("What do you want to report about this user?", comment: "")
            textView.textColor = .lightGray
            textView.text = textViewPlaceholder
        }
    }

    func setupGesture() {
        self.view.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))

        self.view.addGestureRecognizer(tap)

    }

    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
}
