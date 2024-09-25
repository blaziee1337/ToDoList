//
//  TodoListPresenterTests.swift
//  ToDoListTests
//
//  Created by Halil Yavuz on 25.09.2024.
//

import XCTest
@testable import ToDoList

final class TodoListPresenterTests: XCTestCase {

    var presenter: TodoListPresenter!
    var mockView: MockTodoListView!
    var mockInteractor: MockTodoListInteractor!
    var mockRouter: MockTodoListRouter!
    
    override func setUpWithError() throws {
        super.setUp()
        mockView = MockTodoListView()
        mockInteractor = MockTodoListInteractor()
        mockRouter = MockTodoListRouter()
        presenter = TodoListPresenter(view: mockView, interactor: mockInteractor, router: mockRouter)
    }
    
    override func tearDown() {
        presenter = nil
        mockView = nil
        mockInteractor = nil
        mockRouter = nil
        super.tearDown()
    }
    
    func testViewDidLoadCallsFetchTodos() {
        
        presenter.viewDidLoad()
        
       
        XCTAssertTrue(mockInteractor.fetchTodosCalled)
    }
    
    func testDidSelectTodo_CallsNavigateToDetail() {
        
        let todo = ToDo(id: 1, todo: "Test Task", description: nil, completed: false, createdAt: nil)
        
        
        presenter.didSelectTodo(todo: todo)
        
        
        XCTAssertTrue(mockRouter.navigateToDetailCalled)
        XCTAssertEqual(mockRouter.selectedTodo, todo)
    }
    
    func testShowTodos_CallsViewShowTodos() {
        
        let todos = [ToDo(id: 1, todo: "Test Task", description: nil, completed: false, createdAt: nil)]
        presenter.showTodos(todos: todos)
        
        
        XCTAssertTrue(mockView.showTodosCalled)
        XCTAssertEqual(mockView.todosShown, todos)
    }
}



