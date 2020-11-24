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
        
    var taskLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.isUserInteractionEnabled = true
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
    
    lazy var taskTextField : UITextField = {
        
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = .black
        textField.borderStyle = .none
        textField.isHidden = true
        textField.delegate = self
        
        return textField
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        setupViewCode()
        editTaskLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func setViewHierarchy() {
        
        contentView.addSubview(taskLabel)
        contentView.addSubview(checkbox)
        contentView.addSubview(taskTextField)
    }
    
    internal func setConstraints() {
        NSLayoutConstraint.activate([
            checkbox.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            checkbox.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkbox.heightAnchor.constraint(equalTo: taskLabel.heightAnchor),
            checkbox.widthAnchor.constraint(equalTo: checkbox.heightAnchor),
            
            taskLabel.leadingAnchor.constraint(equalTo: checkbox.trailingAnchor, constant: 8),
            taskLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            taskLabel.centerYAnchor.constraint(equalTo: checkbox.centerYAnchor),
            
            taskTextField.leadingAnchor.constraint(equalTo: checkbox.trailingAnchor, constant: 8),
            taskTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            taskTextField.centerYAnchor.constraint(equalTo: checkbox.centerYAnchor)
        ])
    }
    
    private func editTaskLabel() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTouchLabel))
        taskLabel.addGestureRecognizer(tap)
       
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
    
        
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: taskLabel.text ?? "")
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        
        checkbox.setBackgroundImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
        
        //riscado
        taskLabel.attributedText = attributeString
    }
    
    public func unmarkCheckbox() {
        
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: taskLabel.text ?? "")
        
        checkbox.setBackgroundImage(UIImage(systemName: "square"), for: .normal)
        
        //desriscado
        taskLabel.attributedText = attributeString
    }
    
    public func changeCheckboxState() {
        
        isChecked ? markCheckbox() : unmarkCheckbox()
    }
    
    @objc func didTouchCheckbox() {
        
        isChecked.toggle()
    }

    @objc func didTouchLabel() {
        
        taskLabel.isHidden = true
        taskTextField.isHidden = false
        taskTextField.text = taskLabel.text
        checkbox.isUserInteractionEnabled = false
    }
}

extension TaskCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        textField.isHidden = true
        taskLabel.isHidden = false
        self.taskLabel.text = textField.text
        checkbox.isUserInteractionEnabled = true
        return true 
    }
}
