//
//  TaskCompletedTableViewCell.swift
//  MakeItGreat
//
//  Created by Hiago Chagas on 30/11/20.
//

import UIKit

class TaskCompletedTableViewCell: UITableViewCell, ViewCode {
    let taskLabel: UILabel = {
        let lbl = UILabel()
            lbl.text = "Completed task"
            lbl.font = UIFont(name: "Regular", size: 16)
            lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let priorityRect: UIView = {
        let view = UIView()
            view.backgroundColor = .gray
        view.layer.cornerRadius = 2
            view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setViewHierarchy() {
        addSubview(priorityRect)
        addSubview(taskLabel)
        
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            priorityRect.centerYAnchor.constraint(equalTo: centerYAnchor),
            priorityRect.leftAnchor.constraint(equalTo: leftAnchor),
            priorityRect.widthAnchor.constraint(equalToConstant: 20),
            priorityRect.heightAnchor.constraint(equalToConstant: 15),
            taskLabel.leftAnchor.constraint(equalTo: priorityRect.rightAnchor, constant: 10),
            taskLabel.centerYAnchor.constraint(equalTo: priorityRect.centerYAnchor)
        
        ])
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViewCode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
