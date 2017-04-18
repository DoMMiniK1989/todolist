//
//  NotificationSetUp.swift
//  ToDo List
//
//  Created by Dusan Bojkovic on 1/24/17.
//  Copyright © 2017 g7. All rights reserved.
//

import Foundation
import UserNotifications

extension AddTaskViewController {
    
    func schedualNotification(inSeconds: TimeInterval, complision: @escaping (_ success: Bool) -> ()) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        
        let displayDate  = dateFormatter.string(from: datePicker.date)
        
        let notif = UNMutableNotificationContent()
        
        notif.title = taskTF.text!
        notif.subtitle = "\(displayDate)"
        notif.body =  "\(timeTF.text!)"
        notif.sound = UNNotificationSound.default()
        
        let trigger = UNCalendarNotificationTrigger.self.init(dateMatching: NSCalendar.current.dateComponents([.day, .month, .year, .hour, .minute], from: datePicker.date), repeats: false)
        
        let request = UNNotificationRequest(identifier: "myNotif", content: notif, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil {
                print(error as Any)
                complision(false)
            } else {
                complision(true)
            }
        }
     
    }
}
