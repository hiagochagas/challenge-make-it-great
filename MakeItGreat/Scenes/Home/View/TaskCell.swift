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

protocol TaskCheckboxDelegate: class {
    func didChangeStateCheckbox(id: UUID?)
}

class TaskCell: UITableViewCell, ViewCode {
    
    static let reuseIdentifier = "taskCell"
    var returnFromEditingModeAction: ((Bool?) -> Void)?
    weak var taskDelegate: TaskCheckboxDelegate?
    var id: UUID?
    var taskInfo: Task! {
        didSet {
            taskLabel.text = taskInfo.name
            isChecked = taskInfo.status
            id = taskInfo.id
        }
    }
    
    var isChecked: Bool? = nil {
        didSet {
            changeCheckboxState()
        }
    }
    
    var isGhostCell: Bool?
        
    var taskLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        return label
    }()
    
    lazy var checkbox: UIButton = {
        let bttn = UIButton()
        bttn.translatesAutoresizingMaskIntoConstraints = false
        
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
            checkbox.heightAnchor.constraint(equalToConstant: 27),
            checkbox.widthAnchor.constraint(equalTo: checkbox.heightAnchor),
            
            taskLabel.leadingAnchor.constraint(equalTo: checkbox.trailingAnchor, constant: 8),
            taskLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            taskLabel.centerYAnchor.constraint(equalTo: checkbox.centerYAnchor),
            
            taskTextField.leadingAnchor.constraint(equalTo: checkbox.trailingAnchor, constant: 8),
            taskTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            taskTextField.centerYAnchor.constraint(equalTo: checkbox.centerYAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
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
        let checked = isChecked ?? false
        checked ? markCheckbox() : unmarkCheckbox()
    }
    
    public func configureAsNormalTaskCell() {
        taskLabel.textColor = .black
        taskLabel.isUserInteractionEnabled = true
        editTaskLabel()
        changeCheckboxState()
        checkbox.tintColor = .blueActionColor
        checkbox.addTarget(self, action: #selector(didTouchCheckbox), for: .touchUpInside)
    }
    
    public func configureAsGhostCell() {
        taskLabel.textColor = .gray
        taskLabel.text = "Novo Item"
        taskLabel.isUserInteractionEnabled = false
        taskTextField.isHidden = true
        checkbox.setBackgroundImage(UIImage(systemName: "plus"), for: .normal)
        checkbox.tintColor = .gray
        taskLabel.removeGestureRecognizer(UITapGestureRecognizer())
        checkbox.removeTarget(self, action: #selector(didTouchCheckbox), for: .touchUpInside)
    }
    
    @objc func didTouchCheckbox() {
        isChecked?.toggle()
        taskDelegate?.didChangeStateCheckbox(id: id)
    }

    @objc func didTouchLabel() {
        
        taskLabel.isHidden = true
        taskTextField.isHidden = false
        taskTextField.text = taskLabel.text
        checkbox.isUserInteractionEnabled = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isChecked = nil
        isGhostCell = nil
        taskLabel.text = ""
        taskTextField.text = ""
    }
}

extension TaskCell: UITextFieldDelegate {
    
    func callAddCellDelegate() {
    
        taskTextField.isHidden = true
        taskLabel.isHidden = false
        self.taskLabel.text = taskTextField.text
        checkbox.isUserInteractionEnabled = true
        returnFromEditingModeAction?(isGhostCell)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        callAddCellDelegate()
    }
}
