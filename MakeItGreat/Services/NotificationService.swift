//
//  NotificationService.swift
//  MakeItGreat
//
//  Created by Jéssica Araujo on 02/12/20.
//

import UIKit
import UserNotifications

public func getUserNotificationAuthorization() {
    
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) { (userResponse, error) in
        
        if userResponse {
            
            print("Authorization Granted")
            setLocalNotification()
            
        } else {
            
            print(error?.localizedDescription)
        }
    }
}

private func setLocalNotification() {
    
    //setting what i want to show to the user
    
    let notificationContent = UNMutableNotificationContent()
    notificationContent.title = "Bom dia!"
    notificationContent.body = "Vamos começar o dia organizando tarefas? Vai ser divertido!"
    notificationContent.sound = .default
    
    //indicating when the notification should be displayed
    let date = Date(timeIntervalSinceNow: 3600)
    let triggerDaily = Calendar.current.dateComponents([.hour,.minute,.second], from: date)
    
    let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
    
    //choosing identifier to specify the notification
    let notificationIdentifier = "Local Notification"
    
    //creating notification request
    let notificationRequest = UNNotificationRequest(identifier: notificationIdentifier, content: notificationContent, trigger: notificationTrigger)
    
    //adding notification request to User Notification
    UNUserNotificationCenter.current().add(notificationRequest)
}
