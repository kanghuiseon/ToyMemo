//
//  DataManager.swift
//  ToyMemo
//
//  Created by 강희선 on 2020/08/18.
//  Copyright © 2020 강희선. All rights reserved.
//

import Foundation
import CoreData

class DataManager{
    static let shared = DataManager()
    private init(){
        
    }
    
    var mainContext:NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    var memoList = [Memo]()
    // 데이터베이스에서 읽어오기
    func fetchMemo(){
        //날짜를 기준으로 내림차순으로 저장됨
        let request:NSFetchRequest<Memo> = Memo.fetchRequest()
        let sortByDateDesc = NSSortDescriptor(key: "insertDate", ascending: false)
        request.sortDescriptors = [sortByDateDesc]
        
        do{
            memoList = try mainContext.fetch(request)
        }catch{
          print(error)
        }
    }
        // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "ToyMemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
