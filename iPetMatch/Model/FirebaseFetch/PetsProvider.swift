//
//  PetsProvider.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 03/01/2018.
//  Copyright © 2018 Hsiao Ai LEE. All rights reserved.
//

protocol PetsProviderProtocol: class {

    func didFetchMyPets(_ provider: PetsProvider, _ pets: [Pet])
}

class PetsProvider {
    weak var delegate: PetsProviderProtocol?

    func fetchMyPets() {

        guard let uid = Auth.auth().currentUser?.uid else {

            SCLAlertView().showError(NSLocalizedString("Error", comment: ""),
                                     subTitle: NSLocalizedString("User didn't log in", comment: ""))
            return
        }

        let ref = Database.database().reference().child("user-pets").child(uid)
        ref.observeSingleEvent(of: .value) { [weak self] (snapshot) in
                var pets = [Pet]()
                if let petsDic = snapshot.value as? [String: Any] {
                    print(snapshot.value)

                    for (petId, petDic) in petsDic {
                        guard let petDic = petDic as? [String: Any] else { return }

                        let pet = Pet(dictionary: petDic)
                        pets.append(pet)
                    }

                    self?.delegate?.didFetchMyPets(self!, pets)

                } else {

                    SCLAlertView().showWarning(NSLocalizedString("Warning", comment: ""),
                                               subTitle: NSLocalizedString("User didn't add pets yet", comment: ""))
                }
        }
    }
}
