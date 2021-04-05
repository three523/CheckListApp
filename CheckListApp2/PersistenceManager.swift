//
//  PersistenceManager.swift
//  CheckListApp2
//
//  Created by apple on 2021/04/02.
//

import Foundation
import CoreData

class PersistenceManager {
    
    static var shared: PersistenceManager = PersistenceManager()
    
    lazy var persistenceContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CheckListApp2")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T] {
        do {
            let fetchResut = try self.context.fetch(request)
            return fetchResut
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    @discardableResult
    func insertMemo(memo: MemoModel) -> Bool {
        let entity = NSEntityDescription.entity(forEntityName: "Memo", in: self.context)
        
        if let entity = entity {
            let managedObject = NSManagedObject(entity: entity, insertInto: self.context)
            
            managedObject.setValue(memo.id, forKey: "id")
            managedObject.setValue(memo.memoTitle, forKey: "title")
            managedObject.setValue(memo.content, forKey: "content")
            managedObject.setValue(memo.dateString, forKey: "date")
            
            do {
                try self.context.save()
                return true
            } catch {
                print(error.localizedDescription)
                return false
            }
        } else {
            return false
        }
        
    }
    
    @discardableResult
    func delete(object: NSManagedObject) -> Bool {
        self.context.delete(object)
        do {
            try self.context.save()
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    var context: NSManagedObjectContext {
        return self.persistenceContainer.viewContext
    }
    
}
