//
//  ToDoListInteractor.swift
//  ToDoList
//
//  Created by Halil Yavuz on 24.09.2024.
//

import Foundation

protocol ToDoListInteractorProtocol {
    func fetchTodos()
    func deleteTodo(_ todo: ToDo)
}

final class TodoListInteractor: ToDoListInteractorProtocol {
    weak var presenter: ToDoListPresenterProtocol?
    private let coreDataManager: CoreDataManager
    private let networkService: NetworkServiceProtocol
    init(coreDataManager: CoreDataManager, networkService: NetworkServiceProtocol) {
        self.coreDataManager = coreDataManager
        self.networkService = networkService
    }
    
    func fetchTodos() {
        let todos = coreDataManager.fetchLocalTodos()
        
        if !todos.isEmpty {
            let todoModels = todos.map { ToDo(
                id: Int($0.id),
                todo: $0.todo ?? "",
                description: $0.taskDescription,
                completed: $0.completed,
                createdAt: $0.creationTime
            )}
            presenter?.showTodos(todos: todoModels)
            
        } else {
            networkService.fetchTodos { result in
                switch result {
                case .success(let fetchedTodos):
                    self.coreDataManager.saveLocalTodo(todo: fetchedTodos)
                    self.fetchTodos()
                    
                case .failure(let error):
                    self.presenter?.showError(error: error)
                }
            }
        }
    }
    
    func deleteTodo(_ todo: ToDo) {
        DispatchQueue.global(qos: .background).async {
            self.coreDataManager.deleteLocalTodo(todo)
            
            
            let updatedTodos = self.coreDataManager.fetchLocalTodos()
            let todoModels = updatedTodos.map { ToDo(
                id: Int($0.id),
                todo: $0.todo ?? "",
                description: $0.taskDescription,
                completed: $0.completed,
                createdAt: $0.creationTime
            )}
            
            DispatchQueue.main.async {
                self.presenter?.showTodos(todos: todoModels)
            }
        }
    }
}
