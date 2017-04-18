//
//  AddTaskViewController.swift
//  ToDo List
//
//  Created by Dusan Bojkovic on 1/22/17.
//  Copyright © 2017 g7. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class AddTaskViewController: UIViewController {
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var task: Task?
    
    @IBOutlet weak var taskTF: UITextField!
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var timeTF: UITextField!
    @IBOutlet weak var importantMark: UILabel!
    @IBOutlet weak var mySwitch: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // Setting up date and time into the dateTF and timeTF
    @IBAction func datePickerValueChange(_ sender: Any) {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "MMMM dd, YYYY"
        dateTF.text = formatter.string(from: datePicker.date)
        
        formatter.dateFormat = "hh:mm a"
        timeTF.text = formatter.string(from: datePicker.date)
    }
    
    // Setting up task importantce
    @IBAction func mySwitchValueChanged(_ sender: Any) {
        if mySwitch.isOn {
            importantMark.text = "❗️"
        } else {
            importantMark.text = nil
        }
    }
    
    // Setting up info how to use datePicker
    @IBAction func infoForDate(_ sender: Any) {
        let alert = UIAlertController(title: "Calendar", message: "Scroll through calendar to automatically set date and time for your task.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            weak var s = alert
            s?.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Notification access granted")
            } else {
                print(error?.localizedDescription as Any)
            }
        }
        
        if let t = task {
            taskTF.text = t.enterTask
            dateTF.text = t.dateLbl
            timeTF.text = t.timeLbl
        }
    }
    // Saving task into Core Data
    @IBAction func saveTask(_ sender: Any) {
        
        // Checking whether all fields are filled
        if (taskTF.text?.isEmpty)! || (timeTF.text?.isEmpty)! || (dateTF.text?.isEmpty)! {
            let alert = UIAlertController(title: "Ooops!", message: "It seems like you have not filled all required fields in order to schudle your specific task.", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                weak var s = alert
                s?.dismiss(animated: true, completion: nil)
            })
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        } else {
            schedualNotification(inSeconds: TimeInterval(datePicker.minuteInterval)) { (success) in
                if success {
                    print("Successfully scheduled notification")
                } else {
                    print("Error")
                }
            }
            
            if task == nil {
                
                let taskDescription = NSEntityDescription.entity(forEntityName: "Task", in: managedObjectContext)
                task = Task(entity: taskDescription!, insertInto: managedObjectContext)
                
                task?.dateLbl = dateTF.text!
                task?.timeLbl = timeTF.text!
                if mySwitch.isOn {
                    task?.enterTask = "❗️\(taskTF.text!)"
                } else {
                    task?.enterTask = taskTF.text!
                }
                
                do {
                    
                    try managedObjectContext.save()
                    
                    let alert = UIAlertController(title: "Success", message: "Task added.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "mainStoryboard") as! TaskViewController
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    })
                    alert.addAction(action)
                    present(alert, animated: true, completion: nil)
                }
                    
                catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    }
    
    
    
}
