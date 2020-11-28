//
//  GraphicsViewController.swift
//  MakeItGreat
//
import FSCalendar
import UIKit

class GraphicsViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate {
    let contentView = CalendarView()
    override func loadView() {
        view = contentView


    }
    
    override func viewDidLoad() {
        
    }
}


//extension GraphicsViewController: FSCalendarDelegate, FSCalendarDataSource {
//    
//}
