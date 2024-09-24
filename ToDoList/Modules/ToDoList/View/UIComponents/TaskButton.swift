//
//  TaskButton.swift
//  ToDoList
//
//  Created by Halil Yavuz on 24.09.2024.
//

import UIKit

final class TaskButton: UIButton {
    
    
    // MARK: - UI Elements
    private let textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15)
        label.textColor = .lightGray
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 11)
        label.textColor = .white
        return label
    }()
    
    private let countBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 10
        return view
    }()
    
    // MARK: - Initializer
    init(title: String, count: Int, isSelected: Bool = false) {
            super.init(frame: .zero)
            setupUI()
            configure(title: title)
            updateCount("\(count)")
            setSelected(isSelected)
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        addSubview(textLabel)
        addSubview(countBackgroundView)
        countBackgroundView.addSubview(countLabel)
        
        setupConstraints()
    }
    
    // MARK: - Setup Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            textLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            countBackgroundView.leadingAnchor.constraint(equalTo: textLabel.trailingAnchor, constant: 7),
            countBackgroundView.centerYAnchor.constraint(equalTo: centerYAnchor),
            countBackgroundView.widthAnchor.constraint(equalToConstant: 25),
            countBackgroundView.heightAnchor.constraint(equalToConstant: 18),
            countBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            countLabel.centerXAnchor.constraint(equalTo: countBackgroundView.centerXAnchor),
            countLabel.centerYAnchor.constraint(equalTo: countBackgroundView.centerYAnchor)
        ])
    }
    
    // MARK: - Configuration
    func configure(title: String) {
        textLabel.text = title
    }
    
    func setSelected(_ selected: Bool) {
        textLabel.font = selected ? UIFont.boldSystemFont(ofSize: 15) : UIFont.systemFont(ofSize: 15, weight: .medium)
        textLabel.textColor = selected ? .systemBlue : .lightGray
        countBackgroundView.backgroundColor = selected ? .systemBlue : .lightGray
        countBackgroundView.alpha = selected ? 1 : 0.5
        countLabel.textColor = .white
    }
    
    func updateCount(_ count: String) {
        countLabel.text = count
    }
    
        // MARK: - Button Action
        func setButtonAction(target: Any?, action: Selector, for event: UIControl.Event) {
            self.addTarget(target, action: action, for: event)
        }
    }
    
    


