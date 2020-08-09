//
//  ViewController.swift
//  Bad Character app
//
//  Created by Emil Vaklinov on 03/08/2020.
//  Copyright © 2020 Emil Vaklinov. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    
    let coreDataStack = CoreDataStack.shared
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        
        
        
    }
    
    let apiManager = APIManager()
    var selectedIndexPath: IndexPath?
    
    
    var characters: [Character] = []
    var badCharacterApp: [Bad_Character_app] = []
    
    // var score = String(score.Double)
    
    let cellIdentifier = "baseCell"
    
    func search(_ text: String) {
        
        apiManager.searchFor(text) { [unowned self] outcome in
            
            switch outcome {
            case .failure(let errorString):
                print(errorString)
                
            case .success(let data):
                
                do {
                    let result = try JSONParser.parse(data, type: CharacterRoot.self)
                    self.characters = result.characters
                    self.saveInCoreDataWith(array: [])
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        
                    }
                    
                } catch {
                    print("JSON Error: \(error)")
                }
                
            }
        }
    }
    
    
    private func saveInCoreDataWith(array: [Character]) {
        
        let container = coreDataStack.persistentContainer
        
        container.performBackgroundTask() { (context) in
            for jsonObject in self.characters {
                // Fetching the duplicates
                guard let allRepos = self.fetchedResultsController.fetchedObjects else {
                    fatalError("No result in fetchedResultsController")
                }
                //Filter the result
                let matchedValue = allRepos.filter({ $0.char_id == jsonObject.char_id })
                //Save the Data
                if  matchedValue.count == 0 {
                    
                    let repoEntity = Bad_Character_app(context: self.coreDataStack.mainContext)
                    
                    repoEntity.char_id = jsonObject.char_id!
                    repoEntity.name = jsonObject.name
                    repoEntity.occupation = jsonObject.occupation
                    repoEntity.status = jsonObject.status
                    repoEntity.img = jsonObject.img
                    repoEntity.appearance = jsonObject.appearance
                           print(repoEntity)
                }
                
                do {
                    try self.coreDataStack.mainContext.save()
                } catch {
                    fatalError("Failure to save context: \(error)")
                }
                
            }
        }
    }
    lazy var fetchedResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<Bad_Character_app> in
        
        // Create a request to fetch ALL
        let fetchRequest = Bad_Character_app.fetchRequest() as NSFetchRequest<Bad_Character_app>
        
        // Create sort descriptors to sort via Name
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        
        // Add the sort descriptors to the fetch request
        fetchRequest.sortDescriptors = [nameSort]
        
        // Set the batch size
        fetchRequest.fetchBatchSize = 10
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: coreDataStack.mainContext,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        
        frc.delegate = self
        return frc
    }()
}

extension MasterViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        guard let sections = fetchedResultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        // print("number of sections \(sections.count)")
        return sections.count
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let sections = fetchedResultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        
         print("number of object \(sectionInfo.numberOfObjects)")
        navigationItem.title = "\(sectionInfo.numberOfObjects) '\(searchBar.text ?? "")' characters"
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MasterViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        let currentItem = fetchedResultsController.object(at: indexPath)
//        guard let score = currentItem.score else {return cell}
        
        cell.name.text = currentItem.name
//        cell.img.image = currentItem.img
        cell.img.image = UIImage(contentsOfFile: currentItem.img!)
        navigationItem.title = "\(characters.count) '\(searchBar.text ?? "")' characters"
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let repo = fetchedResultsController.object(at: indexPath)
            
            fetchedResultsController.managedObjectContext.delete(repo)
            
            do {
                try fetchedResultsController.managedObjectContext.save()
            } catch {
                print(error)
            }
            
        }
        
    }
    
}



//extension BaseViewController: UITableViewDelegate {}

extension MasterViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search(searchBar.text ?? "BadCharacters")
    }
    
}


extension MasterViewController: NSFetchedResultsControllerDelegate{
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        }
    }
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        performSegue(withIdentifier: "showDetails", sender: tableView)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextViewController = segue.destination as? DetailedViewController,
            let indexPath = selectedIndexPath {
            let currentCharacter = fetchedResultsController.object(at: indexPath)
            nextViewController.selectedCharacter = currentCharacter
            
        }
        
    }
    
}

