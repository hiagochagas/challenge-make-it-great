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
    
    func setViewHierarchy() {
        addSubview(calendar)
        addSubview(doneTasksLabel)
        addSubview(dayOfTheMonthLabel)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            doneTasksLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 23),
            doneTasksLabel.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 20),
            dayOfTheMonthLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 39),
            dayOfTheMonthLabel.topAnchor.constraint(equalTo: doneTasksLabel.bottomAnchor, constant: 22)
        ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let height = UIScreen.main.bounds.height * 0.4
        let width = UIScreen.main.bounds.width * 0.8
        let distanceFromLeft = (UIScreen.main.bounds.width - width) / 2
//        self.backgroundColor = .white
        self.calendar = FSCalendar(frame: CGRect(x: distanceFromLeft, y: 0, width: width, height: height))
        setupViewCode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
