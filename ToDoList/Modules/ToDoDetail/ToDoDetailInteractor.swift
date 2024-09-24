//
//  ToDoDetailInteractor.swift
//  ToDoList
//
//  Created by Halil Yavuz on 25.09.2024.
//

import Foundation

protocol TodoDetailInteractorProtocol: AnyObject {
    func saveTodo(_ todo: ToDo)
}

final class TodoDetailInteractor: TodoDetailInteractorProtocol {
    var coreDataManager: CoreDataManagerProtocol
    
    init(coreDataManager: CoreDataManagerProtocol) {
        self.coreDataManager = coreDataManager
    }
    
    func saveTodo(_ todo: ToDo) {
        coreDataManager.saveLocalTodo(todo: [todo])
    }
}
