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

    var petPersonType: PetPersonType = .both
    var isCatPerson: Bool = false
    var isDogPerson: Bool = false
    var userImage: UIImage?
    var gender: Gender = .male

    var imageURLString: String?
    
    var todayYear: Int {
        
        let todayDate: Date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let todayYesrString = dateFormatter.string(from: todayDate)
        return Int(todayYesrString)!
        
    }

    // Firebase properties

    override func viewDidLoad() {
        super.viewDidLoad()
        genderControl.titles = ["♂︎", "♀︎"]
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

        guard email.contains("@") else {
            SCLAlertView().showWarning(
                NSLocalizedString("Warning", comment: ""),
                subTitle: NSLocalizedString("Invalid Email", comment: "")
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

        guard password.count > 5 else {
            SCLAlertView().showWarning(
                NSLocalizedString("Warning", comment: ""),
                subTitle: NSLocalizedString("Invalid Password\n(6-20 Characters)", comment: "")
            )
            return
        }

        guard

            let birthDay = birthDayTextField.text,
            birthDay != ""
            else {

                SCLAlertView().showWarning(
                    NSLocalizedString("Warning", comment: ""),
                    subTitle: NSLocalizedString("Please pick your birthday", comment: "")
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
        
        guard (todayYear - yearOfBirth) >= 18 else {
            SCLAlertView().showWarning(
                NSLocalizedString("Warning", comment: ""),
                subTitle: NSLocalizedString("Can't sign up,\nif you're under 18", comment: "")
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

        case (true, false): self.petPersonType = .cat
        case (false, true): self.petPersonType = .dog
        case (true, true): self.petPersonType = .both

        default:

            SCLAlertView().showWarning(
                NSLocalizedString("Warning", comment: ""),
                subTitle: NSLocalizedString("Please choose one:\nDog, Cat or Both", comment: "")
            )
            return
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

                    case .invalidEmail:
                        SCLAlertView().showError(
                            NSLocalizedString("Error", comment: ""),
                            subTitle: NSLocalizedString("Invalid email", comment: "")
                        )


                    case .weakPassword, .wrongPassword:
                        SCLAlertView().showError(
                            NSLocalizedString("Error", comment: ""),
                            subTitle: NSLocalizedString("Invalid password", comment: "")
                        )

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

                        NSLocalizedString("Error", comment: ""),

                        subTitle: NSLocalizedString("Invalid Image", comment: "")

                    )
                }

                if let userImageURL = data?.downloadURL()?.absoluteString {

                    self.imageURLString = userImageURL

                }

                // QBSignUp

                QBRequest.signUp(QBCurrentUser,

                                 successBlock: { ( _, QBuser ) in
                                    UserManager.registerForRemoteNotification()
                                    let callingID = QBuser.id

                                    UserManager.instance.currentUser = IPetUser(id: firebaseUid, loginEmail: email, name: name, petPersonType: self.petPersonType, gender: self.gender, yearOfBirth: yearOfBirth, imageURL: self.imageURLString, callingID: callingID)

                                    let userRef = Database.database().reference().child("users").child(firebaseUid)

                                    let values: [String: Any] = [IPetUser.Schema.id: firebaseUid,
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
                                                                        NSLocalizedString("Error", comment: ""),
                                                                        subTitle: NSLocalizedString("Server error\nPlease try again)", comment: "")
                                                                    )
                                                                }
                                                                self.signUpButton.isLoading = false
                                                                AppDelegate.shared.enterPassByLandingView()

                                    })

                },

                                 errorBlock: { (_) in
                                    SCLAlertView().showInfo(
                                        NSLocalizedString("Information", comment: ""),
                                        subTitle: NSLocalizedString("Sign up successfully, please log in again", comment: "")
                                    )

                                    let langdingStoryboard = UIStoryboard(name: "Landing", bundle: nil)
                                    let landingViewController = langdingStoryboard.instantiateViewController(withIdentifier: "LandingViewController")
                                    AppDelegate.shared.window?.rootViewController = landingViewController
                })

            })

        }
    }

}

// Selector functions
extension SignUpViewController {

    @objc func datePickerValueChanged(_ sender: UIDatePicker) {

        let dateFormatter = DateFormatter()
        let timeZoneAbbreviation = NSLocalizedString("CTU", comment: "timeZone")
        let timeZone = TimeZone(abbreviation: timeZoneAbbreviation)
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = NSLocalizedString("dd, MMM, yyyy", comment: "Date format")
        sender.maximumDate = Date()
        birthDayTextField.text = dateFormatter.string(from: sender.date)

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

        SCLAlertView().showWarning(NSLocalizedString("Warning", comment: ""),
                                   subTitle: NSLocalizedString("Camera roll unauthorized", comment: ""))

    }

    // Empty delegate functions
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {

    }

    func fusumaVideoCompleted(withFileURL fileURL: URL) {

    }

}
