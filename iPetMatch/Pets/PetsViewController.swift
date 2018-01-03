//
//  PetsViewController.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 02/01/2018.
//  Copyright © 2018 Hsiao Ai LEE. All rights reserved.
//

import UIKit

class PetsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBAction func addPet(_ sender: UIBarButtonItem) {
        let addPetViewController = AddPetViewController()
        self.present(addPetViewController, animated: true, completion: nil)
    }

    let petProvider = PetsProvider()
    var pets = [Pet]()

    override func viewDidLoad() {
        super.viewDidLoad()
        petProvider.delegate = self
        setupTableView()
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

        let contentViewHeight = UIScreen.main.bounds.height - 20 - 44 - 20
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

}
