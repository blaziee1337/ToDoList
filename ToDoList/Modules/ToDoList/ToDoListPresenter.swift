//
//  ToDoListPresenter.swift
//  ToDoList
//
//  Created by Halil Yavuz on 24.09.2024.
//

import Foundation

protocol ToDoListPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapAddNewTodo()
    func didSelectTodo(todo: ToDo)
    func deleteTodo(todo: ToDo)
    func showTodos(todos: [ToDo])
    func showError(error: Error)
}

final class TodoListPresenter: ToDoListPresenterProtocol {
    weak var view: ToDoListViewProtocol?
    var interactor: ToDoListInteractorProtocol
    var router: TodoListRouterProtocol

    init(view: ToDoListViewProtocol, interactor: ToDoListInteractorProtocol, router: TodoListRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    func viewDidLoad() {
        interactor.fetchTodos()
    }

    func didTapAddNewTodo() {
        router.navigateToNewTodo()
    }

    func didSelectTodo(todo: ToDo) {
        router.navigateToTodoDetail(todo: todo)
    }

    func deleteTodo(todo: ToDo) {
        interactor.deleteTodo(todo)
    }
    
    func showTodos(todos: [ToDo]) {
            view?.showTodos(todos: todos)
        }
    
    func showError(error: Error) {
        view?.showError(error: error)
    }
}

