//
//  GraphicsViewController.swift
//  MakeItGreat
//
import FSCalendar
import UIKit

class GraphicsViewController: UIViewController {
    let contentView = CalendarView()
    var tasksFromDate: [Task] = []
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        contentView.calendar.delegate = self
        contentView.calendar.dataSource = self
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
        contentView.tableView.register(TaskCompletedTableViewCell.self, forCellReuseIdentifier: "TaskCompletedCell")
        displayTasks()
    }
    
    func displayTasks(_ date: Date = Date()) {
        let calendar = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)
        let month = getMonthName(date, calendar: calendar!)
        let weekDay = getDayFromMonth(date, calendar: calendar!)
        guard let day = calendar!.components([.day], from: date).day else {return}
        contentView.dayOfTheMonthLabel.text = "\(weekDay), \(month) \(day)"
        tasksFromDate = Task.fetchAllTasks().filter({Calendar.current.isDate(date, inSameDayAs: $0.finishedAt!) && $0.status == true})
        if tasksFromDate.count == 0 {
            //hide nothing to show here :(
            contentView.nothingToShowLabel.isHidden = false
        } else {
            contentView.nothingToShowLabel.isHidden = true
        }
    }
    
    func reloadCalendarAndTableView() {
        self.contentView.calendar.reloadData()
        self.displayTasks()
        self.contentView.tableView.reloadData()
    }
}


extension GraphicsViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    //changes the background color based on the number of tasks
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        let tasksFromDate = Task.fetchAllTasks().filter({Calendar.current.isDate(date, inSameDayAs: $0.finishedAt!) && $0.status == true})
        switch tasksFromDate.count {
        case 1:
            return .oneTaskInDateColor
        case 2:
            return .twoTaskInDateColor
        case 3:
            return .threeTaskInDateColor
        case 4...:
            return .fourPlusTaskInDateColor
        default:
            return .none
        }
    }
    
    //display the tasks when clicking on a date
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        displayTasks(date)
        contentView.tableView.reloadData()
    }
    func getDayFromMonth(_ date: Date, calendar: NSCalendar) -> String{
        let weekDay = calendar.components([.weekday], from: date).weekday
        switch weekDay {
            case 1:
                return "Sunday".localized()
            case 2:
                return "Monday".localized()
            case 3:
                return "Tuesday".localized()
            case 4:
                return "Wednesday".localized()
            case 5:
                return "Thursday".localized()
            case 6:
                return "Friday".localized()
            case 7:
                return "Saturday".localized()
            default:
                return "None"
        }
    }
    func getMonthName(_ date: Date, calendar: NSCalendar) -> String{
        let month = calendar.components([.month], from: date).month
        switch month {
        case 1:
            return "January".localized()
        case 2:
            return "February".localized()
        case 3:
            return "March".localized()
        case 4:
            return "April".localized()
        case 5:
            return "May".localized()
        case 6:
            return "June".localized()
        case 7:
            return "July".localized()
        case 8:
            return "August".localized()
        case 9:
            return "September".localized()
        case 10:
            return "October".localized()
        case 11:
            return "November".localized()
        case 12:
            return "December".localized()
        default:
            return "None"
        }
    }
}

extension GraphicsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksFromDate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = tasksFromDate[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCompletedCell", for: indexPath) as! TaskCompletedTableViewCell
            cell.taskLabel.text = task.name
            cell.taskLabel.font = UIFont(name: "Varta-SemiBold", size: 15)
            cell.priorityRect.backgroundColor = getColorFromPriority(task)
        return cell
    }
    
    func getColorFromPriority(_ task: Task) -> UIColor {
        switch task.priority {
        case 1:
            return .greenPriority
        case 2:
            return .yellowPriority
        case 3:
            return .redPriority
        default:
            return .gray
        }
    }
    
}
