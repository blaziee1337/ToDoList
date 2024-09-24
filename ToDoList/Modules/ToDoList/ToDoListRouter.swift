//
//  ToDoListRouter.swift
//  ToDoList
//
//  Created by Halil Yavuz on 24.09.2024.
//

import Foundation

protocol TodoListRouterProtocol: AnyObject {
    func navigateToTodoDetail(todo: ToDo)
    func navigateToNewTodo()
}
