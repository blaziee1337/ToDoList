//
//  ToDoListView.swift
//  ToDoList
//
//  Created by Halil Yavuz on 24.09.2024.
//

import UIKit

protocol ToDoListViewProtocol: AnyObject {
    func showTodos(todos: [ToDo])
    func showError(error: Error)
}

final class TodoListViewController: UIViewController, ToDoListViewProtocol {
    var presenter: ToDoListPresenterProtocol?
    var todos: [ToDo] = []
    var filteredTodos: [ToDo] = []
    
    var todosToDo: [ToDo] {
        return todos.filter { !$0.completed }
    }
    
    var todosCompleted: [ToDo] {
        return todos.filter { $0.completed }
    }
    
    // MARK: - UI Elements
    private let tasksTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TodoTableViewCell.self, forCellReuseIdentifier: "TodoCell")
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let taskLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = LocalizedStrings.todayTasks
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        return label
    }()
    
    private let newTaskButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitle(LocalizedStrings.newTasks, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let allTasksButton = TaskButton(title: LocalizedStrings.allTasks, count: 0)
    private let openTasksButton = TaskButton(title: LocalizedStrings.openTasks, count: 0)
    private let closedTasksButton = TaskButton(title: LocalizedStrings.closedTasks, count: 0)
    
    private let dividerTask: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
        updateDateLabel()
        
    }
    
    private func setupUI() {
        view.backgroundColor = .systemGray6
        tasksTableView.delegate = self
        tasksTableView.dataSource = self
        
        [taskLabel, dateLabel, newTaskButton, allTasksButton, dividerTask, openTasksButton, closedTasksButton, tasksTableView].forEach { view.addSubview($0) }
        
        setupConstraints()
        setupButtonActions()
    }
    
    private func setupButtonActions() {
        newTaskButton.addTarget(self, action: #selector(addTodo), for: .touchUpInside)
        allTasksButton.setButtonAction(target: self, action: #selector(showAllTasks), for: .touchUpInside)
        openTasksButton.setButtonAction(target: self, action: #selector(showOpenedTasks), for: .touchUpInside)
        closedTasksButton.setButtonAction(target: self, action: #selector(showClosedTasks), for: .touchUpInside)
    }
    
    private func updateDateLabel() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d MMMM"
        dateLabel.text = dateFormatter.string(from: Date())
    }
    
    private func setupConstraints() {
        allTasksButton.translatesAutoresizingMaskIntoConstraints = false
        openTasksButton.translatesAutoresizingMaskIntoConstraints = false
        closedTasksButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            taskLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            taskLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            
            dateLabel.topAnchor.constraint(equalTo: taskLabel.bottomAnchor, constant: 5),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            
            newTaskButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            newTaskButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            newTaskButton.widthAnchor.constraint(equalToConstant: 130),
            newTaskButton.heightAnchor.constraint(equalToConstant: 40),
            
            allTasksButton.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 20),
            allTasksButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            
            dividerTask.leadingAnchor.constraint(equalTo: allTasksButton.trailingAnchor, constant: 20),
            dividerTask.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 30),
            dividerTask.heightAnchor.constraint(equalToConstant: 18),
            dividerTask.widthAnchor.constraint(equalToConstant: 1),
            
            openTasksButton.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 20),
            openTasksButton.leadingAnchor.constraint(equalTo: dividerTask.trailingAnchor, constant: 20),
            
            closedTasksButton.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 20),
            closedTasksButton.leadingAnchor.constraint(equalTo: openTasksButton.trailingAnchor, constant: 20),
            
            tasksTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tasksTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tasksTableView.topAnchor.constraint(equalTo: allTasksButton.bottomAnchor, constant: 20),
            tasksTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func addTodo() {
        presenter?.didTapAddNewTodo()
    }
    
    @objc private func showAllTasks() {
        filteredTodos = todos
        updateTaskCounts()
        tasksTableView.reloadData()
    }
    
    @objc private func showOpenedTasks() {
        filteredTodos = todosToDo
        updateTaskCounts()
        openTasksButton.setSelected(true)
        closedTasksButton.setSelected(false)
        tasksTableView.reloadData()
    }
    
    @objc private func showClosedTasks() {
        filteredTodos = todosCompleted
        updateTaskCounts()
        closedTasksButton.setSelected(true)
        openTasksButton.setSelected(false)
        tasksTableView.reloadData()
    }
    
    private func updateTaskCounts() {
        
        allTasksButton.configure(title: LocalizedStrings.allTasks)
        allTasksButton.updateCount("\(todos.count)")
        allTasksButton.setSelected(filteredTodos == todos)
        
        openTasksButton.configure(title: "Open")
        openTasksButton.updateCount("\(todosToDo.count)")
        openTasksButton.setSelected(filteredTodos == todosToDo)
        
        closedTasksButton.configure(title: "Closed")
        closedTasksButton.updateCount("\(todosCompleted.count)")
        closedTasksButton.setSelected(filteredTodos == todosCompleted)
        tasksTableView.reloadData()
    }
    
    func showTodos(todos: [ToDo]) {
        self.todos = todos
        filteredTodos = todos
        updateTaskCounts()
        
    }
    
    func showError(error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension TodoListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTodos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! TodoTableViewCell
        let todo = filteredTodos[indexPath.row]
        cell.configure(with: todo)
        return cell
    }
    
    // MARK: - Swipe to delete
    
       func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           if editingStyle == .delete {
                   let todoToDelete = filteredTodos[indexPath.row]
                   presenter?.deleteTodo(todo: todoToDelete)
                   if let index = todos.firstIndex(where: { $0.id == todoToDelete.id }) {
                       todos.remove(at: index)
                   }
                   filteredTodos.remove(at: indexPath.row)
                   tableView.deleteRows(at: [indexPath], with: .fade)
                   updateTaskCounts()
           }
       }
       
       // MARK: - Переход на детальную страницу
    
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           let selectedTodo = filteredTodos[indexPath.row]
           presenter?.didSelectTodo(todo: selectedTodo)
           tableView.deselectRow(at: indexPath, animated: true)
       }
}

extension TodoListViewController: EditTodoViewDelegateProtocol {
    func didUpdateTodo(todo: ToDo?) {
        presenter?.viewDidLoad()
        tasksTableView.reloadData()
    }
    
    
}

