//
//  ToDoDetailPresenter.swift
//  ToDoList
//
//  Created by Halil Yavuz on 25.09.2024.
//

import Foundation

protocol TodoDetailPresenterProtocol: AnyObject {
    func viewDidLoad()
    func saveTodo(todo: ToDo)
    
}

final class TodoDetailPresenter: TodoDetailPresenterProtocol {
    weak var view: TodoDetailViewProtocol?
    var interactor: TodoDetailInteractorProtocol
    var router: TodoDetailRouterProtocol
    var toDo: ToDo?
    weak var delegate: EditTodoViewDelegateProtocol?
    init(view: TodoDetailViewProtocol,
         interactor: TodoDetailInteractorProtocol,
         router: TodoDetailRouterProtocol,
         toDo: ToDo?) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.toDo = toDo
    }

    func viewDidLoad() {
        view?.showTodoDetail(todo: toDo)
    }

    func saveTodo(todo: ToDo) {
        interactor.saveTodo(todo)
        router.dismissDetailView()
        delegate?.didUpdateTodo(todo: toDo)
       
    }
}

