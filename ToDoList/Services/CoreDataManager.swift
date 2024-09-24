//
//  CoreDataManager.swift
//  ToDoList
//
//  Created by Halil Yavuz on 24.09.2024.
//

import UIKit
import CoreData

protocol CoreDataManagerProtocol {
    func saveLocalTodo(todo: [ToDo])
    func fetchLocalTodos() -> [ToDoItem]
    func deleteLocalTodo(_ todo: ToDo)
    func saveContext()
}

final class CoreDataManager: CoreDataManagerProtocol {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TodoModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Сохранение или обновление локальных задач
    func saveLocalTodo(todo: [ToDo]) {
        for todo in todo {
            let fetchRequest: NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", todo.id)
            
            do {
                let results = try context.fetch(fetchRequest)
                if let existingTodo = results.first {
                    // Обновление существующей задачи
                    print("Updating Todo with id: \(todo.id)")
                    existingTodo.todo = todo.todo
                    existingTodo.taskDescription = todo.description ?? ""
                    existingTodo.completed = todo.completed
                    existingTodo.creationTime = todo.createdAt ?? Date()
                } else {
                    // Создание новой задачи
                    let newTodo = ToDoItem(context: context)
                    newTodo.id = Int32(todo.id)
                    newTodo.todo = todo.todo
                    newTodo.taskDescription = todo.description ?? ""
                    newTodo.completed = todo.completed
                    newTodo.creationTime = todo.createdAt ?? Date()
                }
            } catch {
                print("Failed to fetch or update todo: \(error)")
            }
        }
        saveContext()
    }
    
    // MARK: - Загрузка всех локальных задач
    func fetchLocalTodos() -> [ToDoItem] {
        let request: NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch todos: \(error)")
            return []
        }
    }
    
    // MARK: - Удаление задачи
    func deleteLocalTodo(_ todo: ToDo) {
        let fetchRequest: NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", todo.id)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let todoToDelete = results.first {
                print("Deleting Todo with id: \(todo.id)")
                context.delete(todoToDelete)
                saveContext()
            }
        } catch {
            print ("error: \(error)")
        }
    }
    
    // MARK: - Сохранение изменений в Core Data
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                context.rollback()
                print("Failed to save context: \(error)")
            }
        }
    }
}

