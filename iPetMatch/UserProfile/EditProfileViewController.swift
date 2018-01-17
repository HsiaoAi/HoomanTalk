//
//  EditProfileViewController.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 11/01/2018.
//  Copyright © 2018 Hsiao Ai LEE. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet weak var nameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var genderControl: BetterSegmentedControl!
    @IBOutlet weak var birthDayTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var userImageView: UIImageView!
    var isCatPerson: Bool = false {

        didSet {
            if isCatPerson {
                catButton.isSelected = true
                catButton.rightImageSrc = IconImage.catPersonSelected.image
            } else {
                catButton.isSelected = false
                catButton.rightImageSrc = IconImage.catPerson.image
            }
        }
    }
    @IBOutlet weak var catButton: LGButton!
    var isDogPerson: Bool = false {

        didSet {
            if isDogPerson {
                dogButton.isSelected = true
                dogButton.rightImageSrc = IconImage.dogPersonSelected.image
            } else {
                dogButton.isSelected = false
                dogButton.rightImageSrc = IconImage.dogPerson.image
            }
        }
    }
    @IBOutlet weak var dogButton: LGButton!
    var todayYear: Int {
        let todayDate: Date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let todayYesrString = dateFormatter.string(from: todayDate)
        return Int(todayYesrString)!
    }
    var gender: Gender = .male
    var userImage = UIImage()
    var user: IPetUser?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    func setup() {
        let cornerView = UIView(frame: buttonsStackView.bounds)
        cornerView.layer.cornerRadius = 10.0
        cornerView.clipsToBounds = true
        cornerView.backgroundColor = .clear
        view.addSubview(cornerView)
        view.sendSubview(toBack: cornerView)

        genderControl.titles = ["♂︎", "♀︎"]
        guard let disPlayUser = user else { return }
        nameTextField.text = disPlayUser.name
        birthDayTextField.text = String(disPlayUser.yearOfBirth)

        switch disPlayUser.petPersonType {
        case .both:
            self.isCatPerson = true
            self.isDogPerson = true
        case .dog:
            self.isCatPerson = false
            self.isDogPerson = true
        case .cat:
            self.isCatPerson = true
            self.isDogPerson = false
        }

        userImageView.image = userImage
        self.gender = disPlayUser.gender

        let indext: UInt = (self.gender == .male) ? 0 : 1
        do {
            try genderControl.setIndex(indext)
        } catch {}
    }

    @IBAction func tapCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func pickBirthDay(_ sender: UITextField) {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }

    @IBAction func tapGenderControl(_ sender: BetterSegmentedControl) {
        self.gender = (sender.index == 0) ? Gender.male: Gender.female
    }

    @IBAction func addUserImage (_ sender: Any) {
        self.setupFusumaImagePicker()
    }

    @IBAction func tapCatPerson(_ sender: LGButton) {

        self.isCatPerson = (isCatPerson == true) ? false : true
    }

    @IBAction func tapDogPerson(_ sender: LGButton) {

        self.isDogPerson = (isDogPerson == true) ? false : true

    }

    @IBAction func tapSave(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
// Selector functions
extension EditProfileViewController {

    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        let timeZone = TimeZone.ReferenceType.local
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = NSLocalizedString("dd, MMM, yyyy", comment: "Date format")
        sender.maximumDate = Date()
        birthDayTextField.text = dateFormatter.string(from: sender.date)
    }

}

extension EditProfileViewController: FusumaDelegate {

    func setupFusumaImagePicker() {
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        fusuma.cropHeightRatio = 1.0
        fusuma.allowMultipleSelection = false
        userImageView.clipsToBounds = true
        self.present(fusuma, animated: true, completion: nil)
    }

    // Delegate Methods
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        let correctImage = image.fixedOrientation()
        self.userImage = correctImage
        userImageView.contentMode = .scaleAspectFill
        userImageView.image = correctImage
    }

    // When camera roll is not authorized, this method is called.
    func fusumaCameraRollUnauthorized() {

        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alertview = SCLAlertView(appearance: appearance)
        let buttonDone = NSLocalizedString("Done", comment: "")

        alertview.addButton(buttonDone) {
            self.dismiss(animated: true, completion: nil)
        }

        alertview.showWarning(NSLocalizedString("Warning", comment: ""),
                              subTitle: NSLocalizedString("Camera roll unauthorized", comment: ""))

    }

    // Empty delegate functions
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {
    }

    func fusumaVideoCompleted(withFileURL fileURL: URL) {
    }
}
