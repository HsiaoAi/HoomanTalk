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

    override func viewWillAppear(_ animated: Bool) {
        setupSettings()
    }

    func setupSettings() {
        let petTypePreference = UserPreference.shared.petTypePreference
        switch petTypePreference {
        case .dog:
            petTypePersonTextField.text = petType[1]
        case .cat:
            petTypePersonTextField.text = petType[2]
        default:
            petTypePersonTextField.text = petType[0]
        }
        
        
        let gender = UserPreference.shared.genderPreference
        switch gender {
        case .male:
            lookForGenderLabel.text = genderPreferenceType[1]
        case .female:
            lookForGenderLabel.text = genderPreferenceType[2]
        default:
            lookForGenderLabel.text = genderPreferenceType[0]
            
        }
        let maxValue = CGFloat(UserPreference.shared.maxAge)
        let minValue =  CGFloat(UserPreference.shared.minAge)
        ageRangeSlider.selectedMaxValue = maxValue
        ageRangeSlider.selectedMinValue = minValue
        if maxValue == 55.0 {
            ageRangeLabel.text = "\(Int(minValue))-\(Int(maxValue))+"
        } else {
            ageRangeLabel.text = "\(Int(minValue))-\(Int(maxValue))"
        }

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
            switch row {
            case 2:
                UserPreference.shared.petTypePreference = .cat
            case 1:
                UserPreference.shared.petTypePreference = .dog
            case 0:
                UserPreference.shared.petTypePreference = .both
            default:
                break
            }
            self.petTypePersonTextField.resignFirstResponder()
        } else if pickerView === genderPreferencePicker {
            lookForGenderLabel.text = genderPreferenceType[row]

            switch row {
            case 0:
                UserPreference.shared.genderPreference = .both
            case 1:
                UserPreference.shared.genderPreference = .male
            case 2:
                UserPreference.shared.genderPreference = .female
            default:
                break
            }
        }
    }
}

extension FilterViewController: RangeSeekSliderDelegate {
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        
        if maxValue == 55.0 {
            ageRangeLabel.text = "\(Int(minValue))-\(Int(maxValue))+"
        } else {
            ageRangeLabel.text = "\(Int(minValue))-\(Int(maxValue))"
        }
        UserPreference.shared.maxAge = Int(maxValue)
        UserPreference.shared.minAge = Int(minValue)
    }
}
