//
//  ToDoDetailRouter.swift
//  ToDoList
//
//  Created by Halil Yavuz on 25.09.2024.
//

import UIKit

protocol TodoDetailRouterProtocol: AnyObject {
    func dismissDetailView()
}

final class TodoDetailRouter: TodoDetailRouterProtocol {
    weak var viewController: UIViewController?
    
    func dismissDetailView() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}
