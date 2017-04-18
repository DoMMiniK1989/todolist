//
//  TaskViewController.swift
//  ToDo List
//
//  Created by Dusan Bojkovic on 1/22/17.
//  Copyright © 2017 g7. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class TaskViewController: UIViewController {
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var taskDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let request:  NSFetchRequest<NSFetchRequestResult> = Task.fetchRequest()
        task = (try! managedObjectContext.fetch(request) as! [Task])
        self.tableView.reloadData()
        animateTable()
        taskDescription.text = nil
    }
    
    // Declaring entity as array
    var task = [Task]()
    
    func filterTasks(_ searchText: String) {
        let request: NSFetchRequest<NSFetchRequestResult> = Task.fetchRequest()
        let predicate = NSPredicate(format: "enterTask contains[c]%@", searchText)
        request.predicate = predicate
        task = (try! managedObjectContext.fetch(request) as! [Task])
        self.tableView.reloadData()
    }
    
    @IBAction func searchTask(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Search", message: "Enter the name of your task.", preferredStyle: .alert)
        
        alert.addTextField { (taskName: UITextField!) in
            taskName.placeholder = "Task Name"
        }
        
        let searchAction = UIAlertAction(title: "Search", style: .default) { (searchAction) in
            let taskName = alert.textFields![0]
            self.filterTasks(taskName.text!)
            weak var s = alert
            s?.dismiss(animated: true, completion: nil)
            
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (cancelAction) in
            weak var s = alert
            s?.dismiss(animated: true, completion: nil)
        }
        alert.addAction(searchAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func refreshTableView(_ sender: UIBarButtonItem) {
        let request: NSFetchRequest<NSFetchRequestResult> = Task.fetchRequest()
        task = (try! managedObjectContext.fetch(request) as! [Task])
        self.tableView.reloadData()
        animateTable()
        taskDescription.text = nil
    }
    
}
