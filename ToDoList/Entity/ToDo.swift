//
//  ToDo.swift
//  ToDoList
//
//  Created by Halil Yavuz on 24.09.2024.
//

import Foundation

struct ToDosResponse: Codable {
    let todos: [ToDo]
}

struct ToDo: Codable, Equatable {
    let id: Int
    let todo: String
    let description: String?
    let completed: Bool
    let createdAt: Date?
}
