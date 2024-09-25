//
//  MockTodoListInteractor.swift
//  ToDoListTests
//
//  Created by Halil Yavuz on 25.09.2024.
//

import XCTest
@testable import ToDoList

 class MockTodoListInteractor: ToDoListInteractorProtocol {
    
    var fetchTodosCalled = false
    var deleteTodoCalledWithTodo: ToDo?
    func fetchTodos() {
        fetchTodosCalled = true
    }
    
    func deleteTodo(_ todo: ToDoList.ToDo) {
        deleteTodoCalledWithTodo = todo
    }

}
