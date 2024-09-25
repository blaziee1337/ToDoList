//
//  MockTodoListRouter.swift
//  ToDoListTests
//
//  Created by Halil Yavuz on 25.09.2024.
//

import XCTest
@testable import ToDoList

 class MockTodoListRouter: TodoListRouterProtocol {
    
    var navigateToDetailCalled = false
    var navigateToNewTodoCalled = false
    var selectedTodo: ToDo?
    
    func navigateToTodoDetail(todo: ToDoList.ToDo) {
        navigateToDetailCalled = true
        selectedTodo = todo
    }
    
    func navigateToNewTodo() {
        navigateToNewTodoCalled = true
    }
    

}
