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

    var imageURLString: String?

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
        guard email != "" else {

            SCLAlertView().showWarning(
                NSLocalizedString("Warning", comment: ""),
                subTitle: NSLocalizedString("Please enter your email", comment: "")
            )

            return

        }

        guard emailTextField.errorMessage == "" else {

            SCLAlertView().showWarning(

                NSLocalizedString("Warning", comment: ""),

                subTitle: emailTextField.errorMessage!

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

        // Firebase Sign up

        self.signUpButton.isLoading = true

        Auth.auth().createUser(withEmail: email, password: password) { (user: User?, error) in

            // handel error

            if error != nil {

                self.signUpButton.isLoading = false

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

                    self.signUpButton.isLoading = false

                    return

                }
            }

            // Success

            guard let firebaseUid = user?.uid else { return }

            let QBCurrentUser = QBUUser()

            QBCurrentUser.email = email

            QBCurrentUser.password = firebaseUid

            // Upload images to Firebase Storage
            let userImageName = UUID().uuidString

            let storageRef = Storage.storage().reference().child("usersImage").child(firebaseUid).child("\(userImageName).png")

            let metadata = StorageMetadata()

            metadata.contentType = "image/jpeg"

            storageRef.putData(UIImageJPEGRepresentation(userImage, 0.5)!, metadata: metadata, completion: { (data, error) in

                if error != nil {

                    SCLAlertView().showError(

                        NSLocalizedString("Image Error", comment: ""),

                        subTitle: NSLocalizedString("\(error!.localizedDescription)", comment: "")

                    )
                }

                if let userImageURL = data?.downloadURL()?.absoluteString {

                    self.imageURLString = userImageURL

                }

                // QBSignUp

                QBRequest.signUp(QBCurrentUser,

                                 successBlock: { ( _, QBuser ) in

                                    let callingID = QBuser.id

                                    UserManager.instance.currentUser = IPetUser(id: firebaseUid, loginEmail: email, name: name, petPersonType: self.petPersonType, gender: self.gender, yearOfBirth: yearOfBirth, imageURL: self.imageURLString, callingID: callingID)

                                    let userRef = Database.database().reference().child("users").child(firebaseUid)

                                    let values: [String: Any] = [

                                        IPetUser.Schema.id: firebaseUid,

                                        IPetUser.Schema.loginEmail: email,

                                        IPetUser.Schema.name: name,

                                        IPetUser.Schema.petPersonType: self.petPersonType.rawValue,

                                        IPetUser.Schema.gender: self.gender.rawValue,

                                        IPetUser.Schema.yearOfBirth: yearOfBirth,

                                        IPetUser.Schema.imageURL: self.imageURLString ?? "",

                                        IPetUser.Schema.callingID: callingID

                                    ]

                                    userRef.updateChildValues(values,

                                                              withCompletionBlock: { (error, _) in

                                                                if error != nil {

                                                                    SCLAlertView().showError(

                                                                        NSLocalizedString("Firebase Error", comment: ""),

                                                                        subTitle: NSLocalizedString("\(error?.localizedDescription)", comment: "")

                                                                    )

                                                                }

                                                                self.signUpButton.isLoading = false

                                                                AppDelegate.shared.enterPassByLandingView()

                                    })

                },

                                 errorBlock: { (_) in

                                    SCLAlertView().showError(

                                        NSLocalizedString("QuickBlox Error", comment: ""),

                                        subTitle: NSLocalizedString("Sign up successfully, please log in again", comment: "")

                                    )

                                    let langdingStoryboard = UIStoryboard(name: "Landing", bundle: nil)
                                    let landingViewController = langdingStoryboard.instantiateViewController(withIdentifier: "LandingViewController")

                                    AppDelegate.shared.window?.rootViewController = landingViewController

                })

            })

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

        SCLAlertView().showWarning("Warning", subTitle: "Camera roll unauthorized")

    }

    // Empty delegate functions
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {

    }

    func fusumaVideoCompleted(withFileURL fileURL: URL) {

    }

}
