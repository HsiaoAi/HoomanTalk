//
//  PetsViewController.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 02/01/2018.
//  Copyright © 2018 Hsiao Ai LEE. All rights reserved.
//

import UIKit

class PetsViewController: UIViewController {

    @IBAction func addPet(_ sender: UIButton) {
        let addPetViewController = AddPetViewController()
        self.present(addPetViewController, animated: true, completion: nil)
    }

    @IBOutlet weak var tableView: UITableView!

    let petProvider = PetsProvider()
    var pets = [Pet]()

    override func viewDidLoad() {
        super.viewDidLoad()
        petProvider.delegate = self
        setupTableView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        pets = [Pet]()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        petProvider.fetchMyPets()
    }

}

extension PetsViewController: PetsProviderProtocol {

    func didFetchMyPets(_ provider: PetsProvider, _ pets: [Pet]) {
        self.pets = pets
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

}

extension PetsViewController: UITableViewDelegate, UITableViewDataSource {

    func setupTableView() {
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self

        let nib = UINib(nibName: "PetsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "PetsTableViewCell")
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let contentViewHeight = UIScreen.main.bounds.height - 20 - 20
        return contentViewHeight / 3

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return pets.count

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PetsTableViewCell", for: indexPath) as? PetsTableViewCell else { return UITableViewCell()}

        if pets.count > indexPath.row {
            let pet = pets[indexPath.row]
            cell.set(content: pet)
        }
        return cell

    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {

            let pet = pets[indexPath.row]
            let petRef = Database.database().reference().child("pets").child(pet.id!)
            petRef.removeValue()

            let userUid = Auth.auth().currentUser?.uid
            let ownerRef = Database.database().reference().child("user-pets").child(userUid!).child(pet.id!)
            ownerRef.removeValue()

            pets.remove(at: indexPath.row)
            tableView.reloadData()

        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let addPetViewController = AddPetViewController()
        addPetViewController.petToBeEdited = pets[indexPath.row]
        self.present(addPetViewController, animated: true, completion: nil)

    }

}
