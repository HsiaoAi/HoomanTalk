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

    @IBOutlet weak var signUpButton: LGButton!
    
    var petPersonType: PetPersonType = .none

    var isCatPerson: Bool = false

    var isDogPerson: Bool = false

    var userImage: UIImage?

    var gender: Gender = .male

    override func viewDidLoad() {

        super.viewDidLoad()

        setupFusumaImagePicker()

        setupErrorTextFieldHandeler()

        genderControl.titles = ["♂︎", "♀︎"]

    }

    @IBAction func pickBirthDay(_ sender: UITextField) {

        sender.delegate = self

        sender.tag = 3

        let datePickerView = UIDatePicker()

        datePickerView.datePickerMode = .date

        sender.inputView = datePickerView

        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }

    @IBAction func tapGenderControl(_ sender: BetterSegmentedControl) {

      self.gender = (sender.index == 0) ? Gender.male: Gender.female

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

        let email = emailTextField.text!

        guard email != "" else {

            SCLAlertView().showWarning("Warning", subTitle: "Please enter your email")

            return

        }

        guard emailTextField.errorMessage == "" else {

            SCLAlertView().showWarning("Warning", subTitle: emailTextField.errorMessage!)

            return

        }

        guard
            let name = nameTextField.text,

            name != ""

        else {

            SCLAlertView().showWarning("Warning", subTitle: "Please enter your name")

            return
        }

        guard

            let password = passwordTextField.text,

            password != ""

        else {

            SCLAlertView().showWarning("Warning", subTitle: "Please enter password")

            return

        }

        guard passwordTextField.errorMessage == "" else {

            SCLAlertView().showWarning("Warning", subTitle: passwordTextField.errorMessage!)

            return

        }

        guard

            let birthDay = birthDayTextField.text,

            birthDay != ""

            else {

                SCLAlertView().showWarning("Warning", subTitle: "Please enter your birthday")

                return

        }
        
        

        let yearOfBirth = birthDay.components(separatedBy: ", ")[1]

        switch (isCatPerson, isDogPerson) {

        case (true, true): self.petPersonType = .both

                            break

        case (true, false): self.petPersonType = .cat

                            break

        case (false, true): self.petPersonType = .dog

                            break

        default: self.petPersonType = .none

        }
        
        signUpButton.isLoading = true
        // Firebase Sign up
        //Auth.auth()
        
        

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

    @objc func datePickerValueChanged(_ sender: UIDatePicker) {

        let dateFormatter = DateFormatter()

        sender.maximumDate = Date()

        dateFormatter.dateStyle = .medium

        birthDayTextField.text = dateFormatter.string(from: sender.date)

    }

}

extension SignUpViewController: UITextFieldDelegate {

    func setupErrorTextFieldHandeler() {

        emailTextField.delegate = self

        emailTextField.tag = 1

        passwordTextField.delegate = self

        passwordTextField.tag = 2
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if textField.tag == 3 {

            return false

        }

        if let text = textField.text {

            if let floatingLabelTextField = textField as? SkyFloatingLabelTextField {

                if textField.tag == 1 && (text.count < 3 || !text.contains("@")) {

                    floatingLabelTextField.errorMessage = "Invalid Email"

                } else if textField.tag == 2 && text.count < 5 {
                    floatingLabelTextField.errorMessage = "Invalid Password"

                } else {

                    floatingLabelTextField.errorMessage = ""

                }

            }

        }

        return true

    }
}

extension SignUpViewController: FusumaDelegate {

    func setupFusumaImagePicker() {

        let fusuma = FusumaViewController()

        fusuma.delegate = self

        fusuma.cropHeightRatio = 1.0

        fusuma.allowMultipleSelection = false
        
        fusuma.cameraPosition = .front
        

        userImageView.clipsToBounds = true

        self.present(fusuma, animated: true, completion: nil)

    }

    // Delegate Methods
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {

        self.userImage = image

        userImageView.contentMode = .scaleAspectFill

        userImageView.image = image

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
