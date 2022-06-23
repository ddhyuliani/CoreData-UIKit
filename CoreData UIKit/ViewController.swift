//
//  ViewController.swift
//  CoreData UIKit
//
//  Created by Local Administrator on 22/06/22.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var employeeTable: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var items: [Employee] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        employeeTable.delegate = self
        employeeTable.dataSource = self
        
        fetchEmployee()
    }
    
    func fetchEmployee(){
        //fetch the data from the CoreData to display in the TableView
        
        do {
            self.items = try context.fetch(Employee.fetchRequest())
            
            DispatchQueue.main.async {
                self.employeeTable.reloadData()
            }
        }
        catch {
            
        }
    }
    
    @IBAction func addTapped(_ sender: Any) {
        
        //create Alert
        let alert = UIAlertController(title: "Add employee", message: "What's their name?", preferredStyle: .alert)
        alert.addTextField()
        
        //configure button
        let submitButton = UIAlertAction(title: "Add", style: .default) { (action) in
            
            //get the textfield for the alert
            let textfield = alert.textFields?[0]
            
            //create an Employee object
            let newEmployee = Employee(context: self.context)
            newEmployee.name = textfield?.text
            //newEmployee.isMarried = true
            
            //save the data
            do {
                try self.context.save()
            }
            catch {
                
            }

            //re-fetch the data
            self.fetchEmployee()
        }
        //add button
        alert.addAction(submitButton)
        
        //show the alert
        self.present(alert, animated: true, completion: nil)
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //return the number of employee
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = employeeTable.dequeueReusableCell(withIdentifier: "employeeCell") as! EmployeeTableViewCell
        
        //get employee from the array and change the label
        let employee = self.items[indexPath.row]
        cell.nameLabel.text = employee.name
        cell.statusLabel.text = String(employee.isMarried)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let employeeData = self.items[indexPath.row]
        
        //create Alert
        let alert = UIAlertController(title: "Edit employee", message: "Change name", preferredStyle: .alert)
        alert.addTextField()
        
        //get the textfield for the alert
        let textfield = alert.textFields?[0]
        textfield?.text = employeeData.name
        
        let saveButton = UIAlertAction(title: "Save", style: .default) { (action) in
            
            //get the textfield for the alert
            let textfield = alert.textFields?[0]
            
            //edit name property of Employee object
            employeeData.name = textfield?.text
            
            //save the data
            do {
                try self.context.save()
            }
            catch {
                
            }
            
            //re-fetch the data
            self.fetchEmployee()
        }
        //add button
        alert.addAction(saveButton)
        
        //show the alert
        self.present(alert, animated: true, completion: nil)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        //create swipe action
        let action = UIContextualAction(style: .destructive, title: "Delete") {(action, view, completionHandler) in
            
            //which employee to remove
            let employeeToRemove = self.items[indexPath.row]
            
            //remove the employee
            self.context.delete(employeeToRemove)
            
            //save the data
            do {
                try self.context.save()
            }
            catch {
                
            }
            
            //re-fetch the data
            self.fetchEmployee()
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
}



