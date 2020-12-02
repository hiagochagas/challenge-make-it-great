//
//  BottomSheetView.swift
//  MakeItGreat
//

import Foundation
import UIKit

class BottomSheetView: UIView {
    var viewController: BottomSheetViewController?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setConstraints()
//        bottomConstraint = bottomSheet.bottomAnchor.constraint(equalTo: self.bottomAnchor)
//        keyboardNotifications()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var bottomSheet: UIView = {
        let bottomSheet = UIView(frame: .zero)
        bottomSheet.backgroundColor = .white
        bottomSheet.layer.cornerRadius = 30
        bottomSheet.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        bottomSheet.translatesAutoresizingMaskIntoConstraints = false
        return bottomSheet
    }()
    
    @objc lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.setTitleColor(UIColor.blueActionColor, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(UIColor.blueActionColor, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
 
    
    lazy var textFieldTaskTitle: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor.blueSecondaryColor
        textField.placeholder = "title of the task"
        textField.textColor = .black
        textField.textAlignment = .center
        textField.borderStyle = .none
        textField.layer.cornerRadius = 8
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
//    lazy var listPicker: UIPickerView = {
//        let picker = UIPickerView()
//        picker.backgroundColor = .blue
//        return picker
//    }()
    
    lazy var redButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.redPriority
        button.frame = CGRect(x: 0, y: 0, width: 52, height: 24)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "checkmark")?.withTintColor(UIColor.white, renderingMode: .alwaysOriginal), for: .selected)
        return button
    }()
    
    lazy var greenButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.greenPriority
        button.frame = CGRect(x: 0, y: 0, width: 52, height: 24)
        button.layer.cornerRadius = 5
        button.setImage(UIImage(systemName: "checkmark")?.withTintColor(UIColor.white, renderingMode: .alwaysOriginal), for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var yellowButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.yellowPriority
        button.frame = CGRect(x: 0, y: 0, width: 52, height: 24)
        button.layer.cornerRadius = 5
        button.setImage(UIImage(systemName: "checkmark")?.withTintColor(UIColor.white, renderingMode: .alwaysOriginal), for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var listLabel: UILabel = {
        let label = UILabel()
        label.text = "List"
        label.tintColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var textFieldTag: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor.blueSecondaryColor
        textField.placeholder = "@tag"
        textField.textColor = .black
        textField.textAlignment = .center
        textField.borderStyle = .none
        textField.layer.cornerRadius = 8
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var tagLabel: UILabel = {
        let label = UILabel()
        label.text = "Tag"
        label.tintColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var priority: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [redButton, yellowButton, greenButton])
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var priorityLabel: UILabel = {
        let label = UILabel()
        label.text = "Priority"
        label.tintColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    func setConstraints() {
        self.addSubview(bottomSheet)
        bottomSheet.addSubview(saveButton)
        bottomSheet.addSubview(cancelButton)
        bottomSheet.addSubview(textFieldTaskTitle)
        bottomSheet.addSubview(listLabel)
        bottomSheet.addSubview(tagLabel)
        bottomSheet.addSubview(textFieldTag)
        bottomSheet.addSubview(priorityLabel)
        bottomSheet.addSubview(priority)
        
        NSLayoutConstraint.activate([
            bottomSheet.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            bottomSheet.topAnchor.constraint(equalTo: self.topAnchor, constant: 320),
            bottomSheet.leftAnchor.constraint(equalTo: self.leftAnchor),
            bottomSheet.rightAnchor.constraint(equalTo: self.rightAnchor),
        
            saveButton.topAnchor.constraint(equalTo: bottomSheet.topAnchor, constant: 20),
            saveButton.rightAnchor.constraint(equalTo: bottomSheet.rightAnchor, constant: -30),
            
            cancelButton.topAnchor.constraint(equalTo: bottomSheet.topAnchor, constant: 20),
            cancelButton.leftAnchor.constraint(equalTo: bottomSheet.leftAnchor, constant: 30),
            
            textFieldTaskTitle.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 30),
            textFieldTaskTitle.widthAnchor.constraint(equalToConstant: 284),
            textFieldTaskTitle.heightAnchor.constraint(equalToConstant: 34),
            textFieldTaskTitle.centerXAnchor.constraint(equalTo: bottomSheet.centerXAnchor),
            
            listLabel.topAnchor.constraint(equalTo: textFieldTaskTitle.bottomAnchor, constant: 42),
            listLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 35),
            
            tagLabel.topAnchor.constraint(equalTo: listLabel.bottomAnchor, constant: 32),
            tagLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 35),
            
            textFieldTag.topAnchor.constraint(equalTo: listLabel.bottomAnchor, constant: 27),
            textFieldTag.widthAnchor.constraint(equalToConstant: 200),
            textFieldTag.heightAnchor.constraint(equalToConstant: 30),
            textFieldTag.leftAnchor.constraint(equalTo: tagLabel.rightAnchor, constant: 56),
            
            priorityLabel.topAnchor.constraint(equalTo: tagLabel.bottomAnchor, constant: 32),
            priorityLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 35),
            
            priority.topAnchor.constraint(equalTo: tagLabel.bottomAnchor, constant: 32),
            priority.leftAnchor.constraint(equalTo: priorityLabel.rightAnchor, constant: 32),
            priority.widthAnchor.constraint(equalToConstant: 200),
            priority.heightAnchor.constraint(equalToConstant: 24)
            
        ])
    }
    
    
    
//    private func setupDismissKeyboard() {
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
//        tapGesture.cancelsTouchesInView = false
//        self.addGestureRecognizer(tapGesture)
//    }
//
//    @objc func hideKeyboard() {
//        self.endEditing(true)
//    }
    
//    @objc func keyboardWillShow(notification: NSNotification) {
//           if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//           if bottomConstraint.constant == 0 {
//              bottomConstraint.constant = -keyboardSize.height + safeInsets.bottom
//              bottomSheet.layoutIfNeeded()
//            bottomSheet.bounds = CGRect(x: self.bounds.minX, y: self.bounds.minY, width: self.bounds.width, height: bottomSheet.bounds.height + keyboardSize.height)
//            
//           }
//        }
//    }
    
   
//    func keyboardNotifications() {
//        NotificationCenter.default.addObserver(self,
//            selector: #selector(keyboardWillShow),
//            name: NSNotification.Name(rawValue: "keyboardWillShow"),
//            object: nil)
//
//        NotificationCenter.default.addObserver(self,
//            selector: #selector(keyboardWillHide),
//            name: NSNotification.Name(rawValue: "keyboardWillHide"),
//            object: nil)
//    }
//    @objc func keyboardWillHide(notification: NSNotification) {
//           bottomConstraint.constant = 0
//           self.layoutIfNeeded()
//    }
    
}
