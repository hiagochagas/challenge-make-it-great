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
//        mockTask()
        displayTasks()
    }
    
    func mockTask() {
        let model = HomeViewModel()
        guard let task = model.createTask(name: "Test task", viewContext: AppDelegate.viewContext) else {return}
        model.updateTask(task: task, name: "Test task", finishedAt: Date(), lastMovedAt: Date(), priority: 1, status: false, viewContext: AppDelegate.viewContext)
        guard let task2 = model.createTask(name: "Test task", viewContext: AppDelegate.viewContext) else {return}
        model.updateTask(task: task2, name: "Test task", finishedAt: Date(), lastMovedAt: Date(), priority: 2, status: false, viewContext: AppDelegate.viewContext)
        guard let task3 = model.createTask(name: "Test task", viewContext: AppDelegate.viewContext) else {return}
        model.updateTask(task: task3, name: "Test task", finishedAt: Date(), lastMovedAt: Date(), priority: 3, status: true, viewContext: AppDelegate.viewContext)
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
                return "Sunday"
            case 2:
                return "Monday"
            case 3:
                return "Tuesday"
            case 4:
                return "Wednesday"
            case 5:
                return "Thursday"
            case 6:
                return "Friday"
            case 7:
                return "Saturday"
            default:
                return "None"
        }
    }
    func getMonthName(_ date: Date, calendar: NSCalendar) -> String{
        let month = calendar.components([.month], from: date).month
        switch month {
        case 1:
            return "January"
        case 2:
            return "February"
        case 3:
            return "March"
        case 4:
            return "April"
        case 5:
            return "May"
        case 6:
            return "June"
        case 7:
            return "July"
        case 8:
            return "August"
        case 9:
            return "September"
        case 10:
            return "October"
        case 11:
            return "November"
        case 12:
            return "December"
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
