//
//  GraphicsViewController.swift
//  MakeItGreat
//
import FSCalendar
import UIKit

class GraphicsViewController: UIViewController {
    let contentView = CalendarView()
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        contentView.calendar.delegate = self
        contentView.calendar.dataSource = self
    }
}


extension GraphicsViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let cell = calendar.cell(for: date, at: monthPosition)
        let month = getMonthName(date)
        let weekDay = getDayFromMonth(date)
        let numberOfTheMonth = String(cell?.titleLabel.text ?? "0")
        
        contentView.dayOfTheMonthLabel.text = "\(weekDay), \(month) \(String(describing: numberOfTheMonth))"
    }
    func getDayFromMonth(_ date: Date) -> String{
        let calendar = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)
        let weekDay = calendar!.components([.weekday], from: date).weekday
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
    func getMonthName(_ date: Date) -> String{
        let calendar = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)
        let month = calendar!.components([.month], from: date).month
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
