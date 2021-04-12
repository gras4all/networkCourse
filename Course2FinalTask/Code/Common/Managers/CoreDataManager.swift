//
//  CoreDataManager.swift
//  CoreDataStack
//
//  Copyright © 2018 E-legion. All rights reserved.
//

import CoreData

final class CoreDataManager {
    
    static var shared: CoreDataManager = CoreDataManager(modelName: "cache_database")
    
    private let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    //MARK: CoreData Stack initialisation
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func getContext() -> NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func save(context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try getContext().save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func createObject<T: NSManagedObject> (from entity: T.Type) -> T {
        let context = getContext()
        let object = NSEntityDescription.insertNewObject(forEntityName: String(describing: entity), into: context) as! T
        return object
    }
    
    func delete(object: NSManagedObject) {
        let context = getContext()
        context.delete(object)
        save(context: context)
    }
    
    func fetchData<T: NSManagedObject>(for entity: T.Type, predicate: NSPredicate? = nil) -> [T] {
        let context = getContext()
        let request: NSFetchRequest<T>
        var fetchedResult = [T]()
        if #available(iOS 10.0, *) {
            request = entity.fetchRequest() as! NSFetchRequest<T>
        } else {
            let entityName = String(describing: entity)
            request = NSFetchRequest(entityName: entityName)
        }
        request.predicate = predicate
        do {
            fetchedResult = try context.fetch(request)
        } catch {
            debugPrint("Could not fetch: \(error.localizedDescription)")
        }
        return fetchedResult
    }
    
    func fetchUserPosts(userId: String) -> [CPost] {
        let userPostPredicate = NSPredicate(format: "author == %@", userId)
        return CoreDataManager.shared.fetchData(for: CPost.self, predicate: userPostPredicate)
    }
    
    func fetchCurrentUser() -> CUser? {
        return CoreDataManager.shared.fetchData(for: CUser.self).first
    }
    
    // Save methods
    
    func savePostsToStorage(posts: [Post]) {
        let context = CoreDataManager.shared.getContext()
        deletePosts(context: context)
        for post in posts {
            post.prepareForSave()
        }
        CoreDataManager.shared.save(context: context)
    }
    
    func saveUsersToStorage(users: [User]) {
        let context = CoreDataManager.shared.getContext()
        deleteUsers(context: context)
        for user in users {
            user.prepareForSave()
        }
        CoreDataManager.shared.save(context: context)
    }
    
    // Delete methods
    func deletePosts(context: NSManagedObjectContext ) {
        let deletePostsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CPost")
        let deletePostsRequest = NSBatchDeleteRequest(fetchRequest: deletePostsFetch)
        do {
            try context.execute(deletePostsRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    
    func deleteUsers(context: NSManagedObjectContext ) {
        let deleteUsersFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CUser")
        let deleteUsersRequest = NSBatchDeleteRequest(fetchRequest: deleteUsersFetch)
        do {
            try context.execute(deleteUsersRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
        
}


