//
//  ToDoDetailView.swift
//  ToDoList
//
//  Created by Halil Yavuz on 25.09.2024.
//

import UIKit

protocol EditTodoViewDelegateProtocol: AnyObject {
    func didUpdateTodo(todo: ToDo?)
}

protocol TodoDetailViewProtocol: AnyObject {
    func showTodoDetail(todo: ToDo?)
    
}

final class TodoDetailViewController: UIViewController, TodoDetailViewProtocol {
   
    weak var delegate: TodoDetailViewProtocol?
    var todo: ToDo?
    var presenter: TodoDetailPresenterProtocol?
    
    private let taskTitleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Task Title"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let taskDescriptionTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Task Description"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let doneSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()
    
    private let doneLabel: UILabel = {
        let label = UILabel()
        label.text = "Completed"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        button.alpha = 0.5
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupViews()
        setupConstraints()
        setupActions()
        presenter?.viewDidLoad()
        
    }
    
    private func setupViews() {
        view.addSubview(taskTitleTextField)
        view.addSubview(taskDescriptionTextField)
        view.addSubview(doneSwitch)
        view.addSubview(doneLabel)
        view.addSubview(saveButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            taskTitleTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            taskTitleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            taskTitleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            taskDescriptionTextField.topAnchor.constraint(equalTo: taskTitleTextField.bottomAnchor, constant: 20),
            taskDescriptionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            taskDescriptionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            doneLabel.topAnchor.constraint(equalTo: taskDescriptionTextField.bottomAnchor, constant: 20),
            doneLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            doneSwitch.centerYAnchor.constraint(equalTo: doneLabel.centerYAnchor),
            doneSwitch.leadingAnchor.constraint(equalTo: doneLabel.trailingAnchor, constant: 10),
            
            saveButton.topAnchor.constraint(equalTo: doneLabel.bottomAnchor, constant: 30),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 100),
            saveButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupActions() {
        saveButton.addTarget(self, action: #selector(saveTodo), for: .touchUpInside)
        taskTitleTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        taskDescriptionTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }
    
    @objc private func textFieldChanged() {
        validateInputs()
    }
    
    private func validateInputs() {
        let isTitleFilled = !(taskTitleTextField.text?.isEmpty ?? true)
        saveButton.isEnabled = isTitleFilled
        saveButton.alpha = saveButton.isEnabled ? 1.0 : 0.5
    }
    
    func showTodoDetail(todo: ToDo?) {
        if let todo = todo {
            taskTitleTextField.text = todo.todo
            taskDescriptionTextField.text = todo.description
            doneSwitch.isOn = todo.completed
            self.todo = todo
        }
        validateInputs()
    }
    
    @objc private func saveTodo() {
        guard let taskTitle = taskTitleTextField.text,
              let taskDescription = taskDescriptionTextField.text else { return }
        
        let isCompleted = doneSwitch.isOn
        let todoId: Int32
        
        if let existingTodo = self.todo {
            todoId = Int32(existingTodo.id)
        } else {
            todoId = Int32(Int.random(in: 1...Int.max))
        }
        
        let todo = ToDo(
            id: Int(todoId),
            todo: taskTitle,
            description: taskDescription,
            completed: isCompleted,
            createdAt: self.todo?.createdAt ?? Date()
        )
        
        presenter?.saveTodo(todo: todo)
        
    }
    
    
}

