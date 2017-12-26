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

    // Firebase properties

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
        guard email != nil else {

            SCLAlertView().showWarning(
                NSLocalizedString("Warning", comment: ""),
                subTitle: NSLocalizedString("Please enter your email", comment: "")
            )

            return

        }

        guard emailTextField.errorMessage == "" else {

            SCLAlertView().showWarning(

                NSLocalizedString("Warning", comment: ""),

                subTitle: NSLocalizedString("emailTextField.errorMessage!", comment: "")

            )

            return

        }

        guard
            let name = nameTextField.text,

            name != ""

        else {

            SCLAlertView().showWarning(

                NSLocalizedString("Warning", comment: ""),

                subTitle: NSLocalizedString("Please enter your name", comment: "")

            )

            return
        }

        guard

            let password = passwordTextField.text,

            password != ""

        else {

            SCLAlertView().showWarning(

                NSLocalizedString("Warning", comment: ""),

                subTitle: NSLocalizedString("Please enter password", comment: "")

            )

            return

        }

        guard passwordTextField.errorMessage == "" else {

            SCLAlertView().showWarning(

                NSLocalizedString("Warning", comment: ""),

                subTitle: NSLocalizedString(passwordTextField.errorMessage!, comment: "")

            )

            return

        }

        guard

            let birthDay = birthDayTextField.text,

            birthDay != ""

            else {

                SCLAlertView().showWarning(

                    NSLocalizedString("Warning", comment: ""),

                    subTitle: NSLocalizedString("Please enter your birthday", comment: "")

                )

                return

        }

        guard let yearOfBirth = Int(birthDay.components(separatedBy: ", ")[2]) else {

            SCLAlertView().showWarning(

                NSLocalizedString("Warning", comment: ""),

                subTitle: NSLocalizedString("Wrong birthday format", comment: "")

            )

            return

        }

        guard let userImage = self.userImage else {

             SCLAlertView().showWarning(

                NSLocalizedString("Warning", comment: ""),

                subTitle: NSLocalizedString("Please pick your picture", comment: "")

            )

            return

        }

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

        Auth.auth().createUser(withEmail: email, password: password) { (user: User?, error) in

            // handel error

            if error != nil {

                if let errCode = AuthErrorCode(rawValue: error!._code) {

                    switch errCode {

                        case .emailAlreadyInUse:

                            SCLAlertView().showError(

                                NSLocalizedString("Error", comment: ""),

                                subTitle: NSLocalizedString("Email is already in use", comment: "")
                            )

                            break

                        case .invalidEmail:

                            SCLAlertView().showError(

                                NSLocalizedString("Error", comment: ""),

                                subTitle: NSLocalizedString("Invalid email", comment: "")
                            )

                            break

                        case .weakPassword, .wrongPassword:

                            SCLAlertView().showError(

                                NSLocalizedString("Error", comment: ""),

                                subTitle: NSLocalizedString("Invalid password", comment: "")
                            )

                            break

                        default:

                            SCLAlertView().showError(

                                NSLocalizedString("Error", comment: ""),

                                subTitle: NSLocalizedString("Something wrong, plese sign up again", comment: "")

                            )

                    }

                }

                // Success

                guard let firebaseUid = user?.uid else { return }

                let QBCurrentUser = QBUUser()

                QBCurrentUser.login = firebaseUid

                QBCurrentUser.password = password

                // Upload images to Firebase Storage
                let userImageName = UUID().uuidString

                let storageRef = Storage.storage().reference().child("usersImage").child(firebaseUid).child("\(userImageName).png")

                let metadata = StorageMetadata()

                metadata.contentType = "image/png"

                storageRef.putData(UIImagePNGRepresentation(userImage)!, metadata: metadata, completion: { (data, error) in

                    if error != nil {

                        SCLAlertView().showError(

                            NSLocalizedString("Image Error", comment: ""),

                            subTitle: NSLocalizedString("\(error!.localizedDescription)", comment: "")

                        )
                    }

                    if let userImageURL = data?.downloadURL() {

                    }

                })

            // QBSignUp

            QBRequest.signUp(QBCurrentUser,

                             successBlock: { ( _, QBuser ) in

                                QBCurrentUser.blobID = QBuser.blobID

                                print("+++++++++++++++\(QBCurrentUser.blobID)")

                                //                            let tabBarController = TabBarController(itemTypes: [.chat])
                                //
                                //                            AppDelegate.shared.window?.rootViewController = tabBarController }
            },

                             errorBlock: { (errorResponse) in

                                SCLAlertView().showError(

                                    NSLocalizedString("QuickBlox Error", comment: ""),

                                    subTitle: NSLocalizedString("\(errorResponse)", comment: "")

                                )

                })
            }

        }
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

        dateFormatter.dateFormat = "dd, MMM, yyyy"

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

        SCLAlertView().showWarning("Warning", subTitle: "Camera roll unauthorized")

    }

    // Empty delegate functions
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {

    }

    func fusumaVideoCompleted(withFileURL fileURL: URL) {

    }

}
