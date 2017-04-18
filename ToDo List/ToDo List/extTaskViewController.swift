//
//  extensionFile.swift
//  ToDo List
//
//  Created by Dusan Bojkovic on 1/23/17.
//  Copyright © 2017 g7. All rights reserved.
//

import Foundation
import UIKit



extension TaskViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return task.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let ts = task[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = ts.enterTask!
        cell.detailTextLabel?.text = ts.dateLbl!
        
        return cell
    }
    // What happens when user taps onn cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ts = task[(indexPath as NSIndexPath).row]
        
        taskDescription.text = "Selected task: \n \(ts.enterTask!) \n is set to date: \n \(ts.dateLbl!) \n at: \n \(ts.timeLbl!)"
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let deleteTask = task[indexPath.row]
            managedObjectContext.delete(deleteTask)
            //UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["myNotif"])
            
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            do {
                task = try managedObjectContext.fetch(Task.fetchRequest())
            } catch {
                print("Error")
            }
        }
        taskDescription.text = nil
        tableView.reloadData()
    }
    
    func animateTable() {
        tableView.reloadData()
        
        let cells = tableView.visibleCells
        
        let tableViewHeight = tableView.bounds.size.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        
        var delayCounter = 0
        
        for cell in cells {
            UIView.animate(withDuration: 1.75, delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveLinear, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
            
        }
    }
}
