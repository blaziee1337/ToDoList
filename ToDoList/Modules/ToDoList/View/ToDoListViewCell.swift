//
//  ToDoListViewCell.swift
//  ToDoList
//
//  Created by Halil Yavuz on 24.09.2024.
//

import UIKit

final class TodoTableViewCell: UITableViewCell {
    
    private let todoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private let todoDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let creationTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let statusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
        contentView.backgroundColor = .systemGray6
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(creationTimeLabel)
        containerView.addSubview(todoLabel)
        containerView.addSubview(todoDescriptionLabel)
        containerView.addSubview(divider)
        containerView.addSubview(statusImageView)
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            containerView.heightAnchor.constraint(equalToConstant: 130),
            
            todoLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            todoLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -50),
            todoLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            
            todoDescriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            todoDescriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -50),
            todoDescriptionLabel.topAnchor.constraint(equalTo: todoLabel.bottomAnchor, constant: 10),
            todoDescriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: divider.topAnchor, constant: -5),
            
          //  divider.topAnchor.constraint(equalTo: todoDescriptionLabel.bottomAnchor, constant: 10),
            divider.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            divider.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            divider.heightAnchor.constraint(equalToConstant: 1),
            divider.bottomAnchor.constraint(equalTo: creationTimeLabel.topAnchor, constant: -5),
            creationTimeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
          //  creationTimeLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 5),
            creationTimeLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            
            statusImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            statusImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            statusImageView.widthAnchor.constraint(equalToConstant: 30),
            statusImageView.heightAnchor.constraint(equalToConstant: 30)
            
        ])
    }
    
    
    func configure(with todo: ToDo) {
        if todo.completed {
            let attributedString = NSAttributedString(
                string: todo.todo,
                attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
            )
            todoLabel.attributedText = attributedString
        } else {
            todoLabel.attributedText = nil
            todoLabel.text = todo.todo
        }
        
        let imageName = todo.completed ? UIImage(systemName: "checkmark.circle.fill"): UIImage(systemName: "circle")
        todoDescriptionLabel.text = todo.description
        statusImageView.image = imageName
        statusImageView.tintColor = todo.completed ? UIColor.systemBlue : UIColor.systemGray5
        if let createdAt = todo.createdAt {
            creationTimeLabel.text = getDateString(from: createdAt)
        } else {
            creationTimeLabel.text = "Дата не указана"
        }
    }
    
}
private func getDateString(from date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yyyy"
    
    let calendar = Calendar.current
    let today = Date()
    let todayStart = calendar.startOfDay(for: today)
    
    // Проверяем, является ли дата сегодняшней
    if calendar.isDate(date, inSameDayAs: todayStart) {
        dateFormatter.dateFormat = "Сегодня HH:mm"
    } else {
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
    }
    
    return dateFormatter.string(from: date)
    
}

