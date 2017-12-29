//
//  CoreDataStack.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 30/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

class CoreDataStack {

    private lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "IPetMatch")
        container.loadPersistentStores(completionHandler: { _, error in
            
            if let error = error as NSError? {
                fatalError("Unresolved error: \(error), \(error.userInfo)")
            }
            
            return container
        })
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        
        let container = self.persistentContainer
        return container.viewContext
        
    }()
    
}

extension CoreDataStack {
    
    func saveChanges {
        
        if self.saveChanges() {
            
            do {
                try save()
            } catch {
                
                SCLAlertView().showError(NSLocalizedString("Error"),
                                         subTitle: NSLocalizedString("Error: \(error.localizedDescription)")
    
            }
        }
        
    }
    
}
