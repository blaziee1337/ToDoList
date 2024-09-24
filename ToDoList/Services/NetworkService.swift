//
//  NetworkService.swift
//  ToDoList
//
//  Created by Halil Yavuz on 24.09.2024.
//

import Foundation

protocol NetworkServiceProtocol: AnyObject {
    func fetchTodos(completion: @escaping (Result<[ToDo], Error>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
    func fetchTodos(completion: @escaping (Result<[ToDo], Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            guard let url = URL(string: "https://dummyjson.com/todos") else { return }

            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return
                }

                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(.failure(NSError(domain: "Data error", code: 0, userInfo: nil)))
                    }
                    return
                }

                do {
                    let todosResponse = try JSONDecoder().decode(ToDosResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(todosResponse.todos))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
            task.resume()
        }
    }
}
