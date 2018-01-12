//
//  AddPetViewController.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 02/01/2018.
//  Copyright © 2018 Hsiao Ai LEE. All rights reserved.
//

import UIKit

class AddPetViewController: UIViewController {

    var petImage: UIImage?
    var sizes = [String]()
    var petGender: Gender = .male
    var petType: PetType = .dog
    var petToBeEdited: Pet?
    var isShowDetail: Bool = false
    var isUpdate: Bool = false

    @IBOutlet weak var saveOrEditButton: UIButton!
    @IBOutlet weak var loadingImageView: NVActivityIndicatorView!
    @IBOutlet weak var pickImageButton: UIButton!
    @IBOutlet weak var pickSizeButton: UIButton!
    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var nameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var petTypeSegmentedControl: BetterSegmentedControl!
    @IBOutlet weak var sexSegmentedControl: BetterSegmentedControl!
    @IBOutlet weak var breedTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var birthTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var sizeTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var aboutPetTextField: SkyFloatingLabelTextField!
    let loadingImagesManager = LoadingImagesManager()

    @IBOutlet weak var cancelButton: UIButton!
    override func viewDidLoad() {

        super.viewDidLoad()
        setup()
        setupSizePickView()
        setupSegmentedControls()
        saveOrEditButton.addTarget(self, action: #selector(tapSave), for: .touchUpInside)
        navigationController?.navigationBar.barTintColor = .white
        if let pet = petToBeEdited {
            self.isUpdate = true
            self.isShowDetail = true
            showDetail(of: pet)
        } else {

        }

    }
    func setup() {
        let petName = NSLocalizedString("PET NAME", comment: "")
        nameTextField.title = petName
        nameTextField.placeholder = petName
        nameTextField.selectedTitle = NSLocalizedString("Add Pet Name", comment: "")

        let breed = NSLocalizedString("BREED", comment: "")
        breedTextField.title = breed
        breedTextField.placeholder = breed
        breedTextField.selectedTitle = NSLocalizedString("Add pet breed", comment: "")

        let birth = NSLocalizedString("BIRTH", comment: "")
        birthTextField.title = birth
        birthTextField.selectedTitle = NSLocalizedString("Select Pet Birth", comment: "")
        birthTextField.placeholder = birth

        let size = NSLocalizedString("SIZE", comment: "")
        sizeTextField.title = size
        sizeTextField.placeholder = size
        sizeTextField.selectedTitle = NSLocalizedString("Select Pet size", comment: "")

        let content = NSLocalizedString("Description", comment: "")
        aboutPetTextField.title = content
        aboutPetTextField.placeholder = content
        aboutPetTextField.selectedTitle = NSLocalizedString("Give a brief introduction", comment: "")

    }

    @IBAction func pickBirthDay(_ sender: UITextField) {
        sender.delegate = self
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)

    }
    @IBAction func pikcSize(_ sender: UIButton) {
        let picker = CZPickerView(headerTitle: NSLocalizedString("Size", comment: ""), cancelButtonTitle: NSLocalizedString("Cancel", comment: ""), confirmButtonTitle: NSLocalizedString("Confirm", comment: ""))
        picker?.delegate = self
        picker?.dataSource = self
        picker?.needFooterView = true
        picker?.show()
    }

    @IBAction func pickPetImage(_ sender: UIButton) {
        setupFusumaImagePicker()
    }

    @IBAction func tapCancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func tapGender(_ sender: BetterSegmentedControl) {
        self.petGender = (sender.index == 0) ? Gender.male: Gender.female
    }

    @IBAction func tapPetType(_ sender: BetterSegmentedControl) {
        self.petType = (sender.index == 0) ? PetType.dog : PetType.cat
    }

    @objc func tapSave(_ sender: Any) {

        if isShowDetail {
            cancelButton.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
            saveOrEditButton.setTitle(NSLocalizedString("Save", comment: ""), for: .normal)
            nameTextField.isEnabled = true
            sexSegmentedControl.isEnabled = true
            petTypeSegmentedControl.isEnabled = true
            breedTextField.isEnabled = true
            birthTextField.isEnabled = true
            sizeTextField.isEnabled = true
            pickImageButton.isEnabled = true
            pickSizeButton.isEnabled = true
            aboutPetTextField.isEnabled = true
            isShowDetail = false
            return
        }
        let petId = petToBeEdited?.id ?? UUID().uuidString
        guard let name = nameTextField.text,
            !name.isEmpty else {
                SCLAlertView().showWarning(
                    NSLocalizedString("Warning", comment: ""),
                    subTitle: NSLocalizedString("Please enter pet's name", comment: "")
                )
                return
        }

        guard let image = self.petImage else {
            SCLAlertView().showWarning(
                NSLocalizedString("Warning", comment: ""),
                subTitle: NSLocalizedString("Please pick pet's picture", comment: "")
            )
            return
        }

        SVProgressHUD.show(withStatus: NSLocalizedString("Uploading", comment: ""))

        let breeds = breedTextField.text!
        let birth = birthTextField.text!
        let size = sizeTextField.text!
        let about = aboutPetTextField.text!
        var petImageURLString = ""
        guard let owner = UserManager.instance.currentUser else { return }

        let petImageName = UUID().uuidString
        let storageRef = Storage.storage().reference().child("petImages").child(petId).child("\(petImageName).png")

        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        storageRef.putData(UIImageJPEGRepresentation(image, 0.1)!, metadata: metadata, completion: { (data, error) in

            if error != nil {
                SCLAlertView().showError(
                    NSLocalizedString("Image Error.\nPick image again.", comment: ""),
                    subTitle: NSLocalizedString("\(error!.localizedDescription)", comment: "")
                )
            }

            if let petImageURL = data?.downloadURL()?.absoluteString {

                petImageURLString = petImageURL

            }

        let petRef = Database.database().reference().child("pets").child(petId)
        let value = [Pet.Schema.name: name,
                     Pet.Schema.birth: birth,
                     Pet.Schema.breeds: breeds,
                     Pet.Schema.ownerId: owner.id,
                     Pet.Schema.petType: self.petType.rawValue,
                     Pet.Schema.size: size,
                     Pet.Schema.sex: self.petGender.rawValue,
                     Pet.Schema.imageURL: petImageURLString,
                     Pet.Schema.about: about,
                     Pet.Schema.id: petId
        ]
        petRef.updateChildValues(value)

        let refUserPet = Database.database().reference().child("user-pets").child(owner.id).child(petId)

        refUserPet.updateChildValues(value)

        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alertview = SCLAlertView(appearance: appearance)
        let buttonTile = NSLocalizedString("Done", comment: "")

        alertview.addButton(buttonTile) {
            self.dismiss(animated: true, completion: nil)

        }
        SVProgressHUD.dismiss()
            let successString = self.isUpdate ? NSLocalizedString("Edit Successully", comment: "") : NSLocalizedString("Save Successully", comment: "")
        alertview.showSuccess(NSLocalizedString("Success", comment: ""),
                              subTitle: successString)
            })
    }

}

extension AddPetViewController: UITextFieldDelegate {

}

// Selector functions
extension AddPetViewController {

    @objc func datePickerValueChanged(_ sender: UIDatePicker) {

        let dateFormatter = DateFormatter()
        sender.maximumDate = Date()
        dateFormatter.dateFormat = NSLocalizedString("dd, MMMM, yyyy", comment: "Date format")
        birthTextField.text = dateFormatter.string(from: sender.date)

    }
}

// UI functions
extension AddPetViewController {

    func setupSegmentedControls() {
        petTypeSegmentedControl.titles = ["🐶", "🐱"]
        sexSegmentedControl.titles = ["🙋🏻‍♂️", "🙋🏻‍♀️"]
    }

    func setupSizePickView() {

        sizes = [NSLocalizedString("Extra Small: 1 - 4.5 Kg", comment: ""),
                 NSLocalizedString("Small: 5 - 11.5 Kg", comment: ""),
                 NSLocalizedString("Medium : 12 - 18 Kg", comment: ""),
                 NSLocalizedString("Large: 18 - 32 Kg", comment: ""),
                 NSLocalizedString("Extra Large: 32 - 45 Kg", comment: "")
        ]
    }

}

// Fusuma
extension AddPetViewController: FusumaDelegate {

    func setupFusumaImagePicker() {
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        fusuma.cropHeightRatio = 1.0
        fusuma.allowMultipleSelection = false
        petImageView.clipsToBounds = true
        self.present(fusuma, animated: true, completion: nil)
    }

    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {

        let correctImage = image.fixedOrientation()
        self.petImage = correctImage
        petImageView.image = correctImage
        petImageView.contentMode = .scaleAspectFill

    }

    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {

    }

    func fusumaVideoCompleted(withFileURL fileURL: URL) {

    }

    func fusumaCameraRollUnauthorized() {

        SCLAlertView().showWarning(NSLocalizedString("Warning", comment: ""),
                                   subTitle: NSLocalizedString("Camera roll unauthorized", comment: ""))

    }

}

extension AddPetViewController {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}

extension AddPetViewController: CZPickerViewDelegate, CZPickerViewDataSource {
    func numberOfRows(in pickerView: CZPickerView!) -> Int {
        return sizes.count
    }

    func czpickerViewDidClickCancelButton(_ pickerView: CZPickerView!) {
        self.sizeTextField.resignFirstResponder()

    }

    func czpickerView(_ pickerView: CZPickerView!, titleForRow row: Int) -> String! {

        return sizes[row]
    }

    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemAtRow row: Int) {

        sizeTextField.text = sizes[row]

        self.sizeTextField.resignFirstResponder()
    }

}
extension AddPetViewController {

    func showDetail(of pet: Pet) {

        petImageView.contentMode = .scaleAspectFill
        petImageView.clipsToBounds = true
        petImageView.image = nil
        let imageAdress = pet.imageURL

        loadingImagesManager.downloadAndCacheImage(urlString: imageAdress!, imageView: petImageView, activityIndicatorView: loadingImageView, placeholderImage: #imageLiteral(resourceName: "icon-pet"))
        self.petImage = petImageView.image
        nameTextField.isEnabled = false
        nameTextField.text = pet.name ?? ""
        sexSegmentedControl.isEnabled = false
        let sexIndex: UInt = (pet.sex! == .male) ? 0 : 1
        do {
            try sexSegmentedControl.setIndex(sexIndex)
        } catch {
            print(error)
        }
        petTypeSegmentedControl.isEnabled = false
        let typeIndex: UInt = (pet.petType == .dog) ? 0 : 1
        do {
            try petTypeSegmentedControl.setIndex(typeIndex)
        } catch {
            print(error)
        }
        breedTextField.isEnabled = false
        breedTextField.text = pet.breeds ?? ""
        birthTextField.isEnabled = false
        birthTextField.text = pet.birth ?? ""
        sizeTextField.isEnabled = false
        sizeTextField.text = pet.size?.rawValue ?? ""
        pickImageButton.isEnabled = false
        pickSizeButton.isEnabled = false
        aboutPetTextField.text = pet.about ?? ""
        aboutPetTextField.isEnabled = false
        cancelButton.setTitle(NSLocalizedString("Back", comment: ""), for: .normal)
        saveOrEditButton.setTitle(NSLocalizedString("Edit", comment: ""), for: .normal)
    }
}
