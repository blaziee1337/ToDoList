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
