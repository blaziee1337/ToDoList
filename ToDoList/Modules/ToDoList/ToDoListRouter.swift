//
//  ToDoListRouter.swift
//  ToDoList
//
//  Created by Halil Yavuz on 24.09.2024.
//

import UIKit

protocol TodoListRouterProtocol: AnyObject {
    func navigateToTodoDetail(todo: ToDo)
    func navigateToNewTodo()
}

final class TodoListRouter: TodoListRouterProtocol {
    weak var viewController: UIViewController?

    func navigateToTodoDetail(todo: ToDo) {
        guard let vc = viewController, let editTodoVC = vc as? EditTodoViewDelegateProtocol else { return }
        let detailVC = createDetailTodoModule(todo: todo, delegate: editTodoVC)
        detailVC.modalPresentationStyle = .pageSheet
        if let sheet = detailVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
    
        viewController?.navigationController?.present(detailVC, animated: true)
        
    }
    
    func navigateToNewTodo() {
    
        guard let vc = viewController, let editTodoVC = vc as? EditTodoViewDelegateProtocol else { return }
        let newTodoVC = createDetailTodoModule(todo: nil, delegate: editTodoVC)
        newTodoVC.modalPresentationStyle = .pageSheet
        
        if let sheet = newTodoVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        
        viewController?.present(newTodoVC, animated: true, completion: nil)
    }
    
    static func createModule() -> UIViewController {
        let view = TodoListViewController()
        let coreDataManager = CoreDataManager()
        let networkService = NetworkService()
        let interactor = TodoListInteractor(coreDataManager: coreDataManager, networkService: networkService)
        let router = TodoListRouter()
        let presenter = TodoListPresenter(view: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
    
    private func createDetailTodoModule(todo: ToDo?, delegate: EditTodoViewDelegateProtocol) -> UIViewController {
        let view = TodoDetailViewController()
        let coreDataManager = CoreDataManager()
        let interactor = TodoDetailInteractor(coreDataManager: coreDataManager)
        let router = TodoDetailRouter()
        let presenter = TodoDetailPresenter(view: view, interactor: interactor, router: router, toDo: todo)
        presenter.delegate = delegate
        view.presenter = presenter
        router.viewController = view
        
        return view
    }
    
    
}
