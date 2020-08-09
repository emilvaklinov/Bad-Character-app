//
//  DetailedViewController.swift
//  Bad Character app
//
//  Created by Emil Vaklinov on 04/08/2020.
//  Copyright © 2020 Emil Vaklinov. All rights reserved.
//

import UIKit

typealias RepoDetail = (String, String)
class DetailedViewController: UITableViewController {

    @IBOutlet weak var detailedTableView: UITableView!
    
    
    var selectedCharacter: Bad_Character_app?
       var content = [URL]()
       
       let coreDataStack = CoreDataStack.shared
       
       var characters: [Character] = []
       
       //   var repoDetails: [RepoDetail] = []
       
       override func viewDidLoad() {
           super.viewDidLoad()
           
           detailedTableView.estimatedRowHeight = 80.00
           detailedTableView.rowHeight = UITableView.automaticDimension
          

       }
       
       
       
       func details() -> [(String, String)] {
           var characters: [(String, String)] = []
           
        if let name = selectedCharacter?.name,
//        let img = selectedCharacter?.img,
        let occupation = selectedCharacter?.occupation,
        let status = selectedCharacter?.status
//        let appearance = selectedCharacter?.appearance
        {
            let charachterName = "\(name)..."
            characters.append(("Name:", charachterName))
            characters.append(("Occupation:", occupation))
            characters.append(("Status:", status))
//            characters.append(("Appearanance:", appearance))
            }
           
           return characters
       }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }
    
override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // Dequeue the cell to display the user details
    let cell = detailedTableView.dequeueReusableCell(withIdentifier: "detailedCell", for: indexPath)
    return cell
    }
}

