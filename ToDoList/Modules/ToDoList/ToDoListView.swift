//
//  ToDoListView.swift
//  ToDoList
//
//  Created by Halil Yavuz on 24.09.2024.
//

import Foundation

protocol ToDoListViewProtocol: AnyObject {
    func showTodos(todos: [ToDo])
    func showError(error: Error)
}
