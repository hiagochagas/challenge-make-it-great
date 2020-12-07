//
//  CalendarView.swift
//  MakeItGreat
//
//  Created by Tales Conrado on 20/11/20.
//

import UIKit
import FSCalendar
class CalendarView: UIView, ViewCode {
    var calendar: FSCalendar!
    
    let doneTasksLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Done Tasks"
        lbl.font = .systemFont(ofSize: 20)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let dayOfTheMonthLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Monday, 1"
        lbl.font = .systemFont(ofSize: 16, weight: .semibold)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let tableView: UITableView = {
        let table = UITableView()
            table.separatorStyle = .none
            table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    let nothingToShowLabel: UILabel = {
        let label = UILabel()
        label.text = "Nothing to show here :("
        label.font = .systemFont(ofSize: 16)
        label.tintColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setViewHierarchy() {
        addSubview(calendar)
        addSubview(doneTasksLabel)
        addSubview(dayOfTheMonthLabel)
        addSubview(tableView)
        addSubview(nothingToShowLabel)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            doneTasksLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 23),
            doneTasksLabel.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 20),
            dayOfTheMonthLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 39),
            dayOfTheMonthLabel.topAnchor.constraint(equalTo: doneTasksLabel.bottomAnchor, constant: 22),
            tableView.topAnchor.constraint(equalTo: dayOfTheMonthLabel.bottomAnchor, constant: 10),
            tableView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.327),
            tableView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 78),
            tableView.leftAnchor.constraint(equalTo: dayOfTheMonthLabel.leftAnchor, constant: 0),
            nothingToShowLabel.centerXAnchor.constraint(equalTo: tableView.centerXAnchor, constant: -20),
            nothingToShowLabel.centerYAnchor.constraint(equalTo: tableView.centerYAnchor, constant: -40)
        ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let height = UIScreen.main.bounds.height * 0.4
        let width = UIScreen.main.bounds.width * 0.8
        let distanceFromLeft = (UIScreen.main.bounds.width - width) / 2
        self.calendar = FSCalendar(frame: CGRect(x: distanceFromLeft, y: 0, width: width, height: height))
        self.calendar.placeholderType = .none
        self.calendar.appearance.headerTitleColor = .black
        self.calendar.appearance.weekdayTextColor = .blueActionColor
        setupViewCode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
