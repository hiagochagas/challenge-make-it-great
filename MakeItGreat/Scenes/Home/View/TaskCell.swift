//
//  TaskCell.swift
//  MakeItGreat
//
//  Created by Tales Conrado on 20/11/20.
//

import UIKit

enum TaskCellPriority {
    case high
    case medium
    case low
}

class TaskCell: UITableViewCell, ViewCode {
    
    static let reuseIdentifier = "taskCell"
    
    var isChecked: Bool = false {
        didSet {
            changeCheckboxState()
        }
    }
        
    let taskLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        
        return label
    }()
    
    lazy var checkbox: UIButton = {
        let bttn = UIButton()
        bttn.translatesAutoresizingMaskIntoConstraints = false
        bttn.setBackgroundImage(UIImage(systemName: "square"), for: .normal)
        bttn.tintColor = .blueActionColor
        bttn.addTarget(self, action: #selector(didTouchCheckbox), for: .touchUpInside)
        
        return bttn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViewCode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func setViewHierarchy() {
        contentView.addSubview(taskLabel)
        contentView.addSubview(checkbox)
    }
    
    internal func setConstraints() {
        NSLayoutConstraint.activate([
            checkbox.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            checkbox.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkbox.heightAnchor.constraint(equalTo: taskLabel.heightAnchor),
            checkbox.widthAnchor.constraint(equalTo: checkbox.heightAnchor),
            
            taskLabel.leadingAnchor.constraint(equalTo: checkbox.trailingAnchor, constant: 8),
            taskLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            taskLabel.centerYAnchor.constraint(equalTo: checkbox.centerYAnchor)
        ])
    }
    
    public func setTaskLabelText(_ text: String) {
        taskLabel.text = text
    }
    
    public func setTaskCellPriorityColor(priority: TaskCellPriority) {
        switch priority {
        case .high:
            checkbox.tintColor = .redPriority
        case .medium:
            checkbox.tintColor = .yellowPriority
        case .low:
            checkbox.tintColor = .greenPriority
        }
    }
        
    public func markCheckbox() {
        checkbox.setBackgroundImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
        //riscado
    }
    
    public func unmarkCheckbox() {
        checkbox.setBackgroundImage(UIImage(systemName: "square"), for: .normal)
        //desriscado
    }
    
    public func changeCheckboxState() {
        isChecked ? markCheckbox() : unmarkCheckbox()
    }
    
    @objc func didTouchCheckbox() {
        isChecked.toggle()
    }
}
