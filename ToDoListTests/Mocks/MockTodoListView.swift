//
//  MockTodoListView.swift
//  ToDoListTests
//
//  Created by Halil Yavuz on 25.09.2024.
//

import XCTest
@testable import ToDoList

class MockTodoListView: ToDoListViewProtocol {
    var showTodosCalled = false
    var todosShown: [ToDo] = []
    
    func showTodos(todos: [ToDo]) {
        showTodosCalled = true
        todosShown = todos
    }
    
    func showError(error: Error) {
        
    }
}
