//
//  FavoriteCoinStorage.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/30.
//

import Foundation
import CoreData

protocol FavoriteCoinRepository {
    func fetch() -> [String]
    func insert(uuid: String) -> Bool
    func delete(uuid: String) -> Bool
}


struct FavoriteCoinStorage: FavoriteCoinRepository {
    
    private let container: NSPersistentContainer
    private let fetchRequest: NSFetchRequest<FavoriteMO>
    private let context: NSManagedObjectContext
    private let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
        self.container = NSPersistentContainer(name: modelName)
        self.fetchRequest = FavoriteMO.fetchRequest()
        container.loadPersistentStores { store, error in
            if error != nil {
                fatalError()
            }
        }
        self.context = container.viewContext
    }
    
    func fetch() -> [String] {
        fetchRequest.predicate = nil
        guard let favorite = try? context.fetch(fetchRequest) else {
            return []
        }
        let uuids = favorite.compactMap { object in
            object.uuid
        }
        return uuids
    }
    
    @discardableResult
    func insert(uuid: String) -> Bool {
        
        guard let object = NSEntityDescription.insertNewObject(forEntityName: "Favorite", into: context) as? FavoriteMO else {
            return false
        }
        
        object.uuid = uuid
        return save()
    }
    
    
    func delete(uuid: String) -> Bool {
        
        fetchRequest.predicate = NSPredicate(format: "uuid == %@",
                                             uuid as String)
        
        guard let favorite = try? context.fetch(fetchRequest),
              let favoriteMOfirst = favorite.first else {
            return false
        }
        
        let object = context.object(with: favoriteMOfirst.objectID)
        context.delete(object)
        
        return save()
    }
    
    private func save() -> Bool {
        do {
            try context.save()
            return true
        } catch {
            context.rollback()
            return false
        }
    }
    
}
