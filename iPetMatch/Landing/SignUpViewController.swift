//
//  SignUpViewController.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 22/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!

    @IBOutlet weak var nameTextField: SkyFloatingLabelTextField!

    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    
    
    @IBOutlet weak var birthDayTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var userImageView: UIImageView!

    @IBOutlet weak var genderControl: BetterSegmentedControl!

    var petPersonType: PetPersonType = .none

    var isCatPerson: Bool = false

    var isDogPerson: Bool = false

    var userImage: UIImage?

    var gender: Gender = .male

    override func viewDidLoad() {

        super.viewDidLoad()

        setupFusumaImagePicker()

        genderControl.titles = ["♂︎", "♀︎"]

    }
    
    
    @IBAction func pickBirthDay(_ sender: UITextField) {
        
        let datePickerView = UIDatePicker()
        
        datePickerView.datePickerMode = .date
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }
    
    @IBAction func tapGenderControl(_ sender: BetterSegmentedControl) {

      self.gender = ( sender.index == 0) ? Gender.male: Gender.female

        print(self.gender)

    }

    @IBAction func tapSignupButton(_ sender: LGButton) {

        signUp()

    }

    @IBAction func addUserImage (_ sender: Any) {

        self.setupFusumaImagePicker()

    }

    @IBAction func tapCatPerson(_ sender: LGButton) {

        if !sender.isSelected {

            sender.isSelected = true

            isCatPerson = true

            sender.rightImageSrc = IconImage.catPersonSelected.image

        } else {

            sender.isSelected = false

            isCatPerson = false

            sender.rightImageSrc = IconImage.catPerson.image

        }

    }

    @IBAction func tapDogPerson(_ sender: LGButton) {

        if !sender.isSelected {

            sender.isSelected = true

            isDogPerson = true

            sender.rightImageSrc = IconImage.dogPersonSelected.image

        } else {

            sender.isSelected = false

            isDogPerson = false

            sender.rightImageSrc = IconImage.dogPerson.image

        }

    }

    func signUp() {

        // Todo: Alert

        let email = emailTextField.text!

        guard email != "" else {

            SCLAlertView().showInfo("Imcompleted Info", subTitle: "Please enter your email")

            return

        }

        guard let name = nameTextField.text else {

            return
        }

        guard let password = passwordTextField.text,

            password.count > 5 else {

                return

        }

        var currentUser = QBUUser()

        currentUser.login = email

        currentUser.password = password

        QBRequest.signUp(currentUser,

                         successBlock: { _, _ in

                            let tabBarController = TabBarController(itemTypes: [.chat])

                            AppDelegate.shared.window?.rootViewController = tabBarController },

                         errorBlock: nil )

    }

    func logOut() {

        QBRequest.logOut(
            successBlock: nil,
            errorBlock: nil
        )
    }

}

// Selector functions
extension SignUpViewController {
    
    @objc func datePickerValueChanged(_ sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .medium
        
        birthDayTextField.text = dateFormatter.string(from: sender.date)
        
    }
    
}

extension SignUpViewController: FusumaDelegate {

    func setupFusumaImagePicker() {

        let fusuma = FusumaViewController()

        fusuma.delegate = self

        fusuma.cropHeightRatio = 1.0

        fusuma.allowMultipleSelection = false

        self.present(fusuma, animated: true, completion: nil)

    }

    // Delegate Methods
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {

        self.userImage = image

        userImageView.image = image

        userImageView.contentMode = .scaleAspectFill

        userImageView.clipsToBounds = true

        // Upload image to Firebase and get the url

    }

    // When camera roll is not authorized, this method is called.
    func fusumaCameraRollUnauthorized() {

        print("Camera roll unauthorized")

    }

    // Empty delegate functions
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {

    }

    func fusumaVideoCompleted(withFileURL fileURL: URL) {

    }

}
