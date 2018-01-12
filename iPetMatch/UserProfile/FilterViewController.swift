//
//  FilterViewController.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 12/01/2018.
//  Copyright © 2018 Hsiao Ai LEE. All rights reserved.
//

import UIKit

class FilterViewController: UITableViewController {
    @IBOutlet weak var petTypePersonTextField: UITextField!
    @IBOutlet weak var lookForGenderLabel: UILabel!
    let petTypePicker = CZPickerView(headerTitle: NSLocalizedString("Pet Person", comment: ""), cancelButtonTitle: NSLocalizedString("Cancel", comment: ""), confirmButtonTitle: NSLocalizedString("Confirm", comment: ""))
    let petType = [NSLocalizedString("Dog and Cat", comment: ""),
                   NSLocalizedString("Dog", comment: ""),
                   NSLocalizedString("Cat", comment: "")]

    let genderPreferencePicker = CZPickerView(headerTitle: NSLocalizedString("Gender", comment: ""), cancelButtonTitle: NSLocalizedString("Cancel", comment: ""), confirmButtonTitle: NSLocalizedString("Confirm", comment: ""))

    let genderPreferenceType = [NSLocalizedString("Male and Female", comment: ""),
                                NSLocalizedString("Male", comment: ""),
                                NSLocalizedString("Female", comment: "")]

    @IBOutlet weak var ageRangeLabel: UILabel!

    @IBOutlet weak var ageRangeSlider: RangeSeekSlider!

    override func viewDidLoad() {
        super.viewDidLoad()
        ageRangeSlider.delegate = self
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }

    @IBAction func tapPetType(_ sender: Any) {
        petTypePicker?.delegate = self
        petTypePicker?.dataSource = self
        petTypePicker?.needFooterView = true
        petTypePicker?.show()

    }

    @IBAction func tapLookforGenderButton(_ sender: Any) {
        genderPreferencePicker?.delegate = self
        genderPreferencePicker?.dataSource = self
        genderPreferencePicker?.needFooterView = true
        genderPreferencePicker?.show()
    }
}
extension FilterViewController: CZPickerViewDelegate, CZPickerViewDataSource {
    func numberOfRows(in pickerView: CZPickerView!) -> Int {
        if pickerView === petTypePicker {
            return petType.count
        } else if pickerView === genderPreferencePicker {
            return genderPreferenceType.count
        }
        return 0
    }

    func czpickerViewDidClickCancelButton(_ pickerView: CZPickerView!) {
        self.petTypePersonTextField.resignFirstResponder()
    }

    func czpickerView(_ pickerView: CZPickerView!, titleForRow row: Int) -> String! {
        if pickerView === petTypePicker {
            return petType[row]
        } else if pickerView === genderPreferencePicker {
            return genderPreferenceType[row]
        }
        return ""

    }

    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemAtRow row: Int) {

        if pickerView === petTypePicker {
            petTypePersonTextField.text = petType[row]
            switch petType[row] {
            case "Both":
                UserSetting.lookForPetType = nil
            case "Dog":
                UserSetting.lookForPetType = .dog
            case "Dog and Cat":
                UserSetting.lookForPetType = .cat
            default:
                break
            }
            self.petTypePersonTextField.resignFirstResponder()
        } else if pickerView === genderPreferencePicker {
            lookForGenderLabel.text = genderPreferenceType[row]

            switch genderPreferenceType[row] {
            case "Male and Female":
                UserSetting.lookForGender = nil
            case "Male":
                UserSetting.lookForGender = .male
            case "Female":
                UserSetting.lookForGender = .female
            default:
                break
            }
        }
    }
}

extension FilterViewController: RangeSeekSliderDelegate {
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        UserSetting.ageRange = (Int(minValue), Int(maxValue))
        if maxValue == 55.0 {
            ageRangeLabel.text = "\(Int(minValue))-\(Int(maxValue))+"
        } else {
            ageRangeLabel.text = "\(Int(minValue))-\(Int(maxValue))"
        }
    }
}
