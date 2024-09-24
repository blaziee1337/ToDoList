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
