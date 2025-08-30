//
//  StorageManager.swift
//  TaskList
//
//  Created by serj on 30.08.2025.
//

import CoreData

final class StorageManager {
    static let shared = StorageManager()
    
    private init() {}
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskList")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    private var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    // MARK: - Core Data Saving support
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - CRUD Methods
    
    /// Получить все задачи
    func fetchTasks() -> [ToDoTask] {
        let fetchRequest = ToDoTask.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Ошибка загрузки задач:", error)
            return []
        }
    }
    
    /// Создать задачу
    @discardableResult
    func createTask(with title: String) -> ToDoTask {
        let task = ToDoTask(context: context)
        task.title = title
        saveContext()
        return task
    }
    
    /// Удалить задачу
    func deleteTask(_ task: ToDoTask) {
        context.delete(task)
        saveContext()
    }
    
    /// Обновить задачу
    func updateTask(_ task: ToDoTask, newTitle: String) {
        task.title = newTitle
        saveContext()
    }
}
