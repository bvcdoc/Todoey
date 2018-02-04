//
//  ViewController.swift
//  Todoey
//
//  Created by William Becker on 2/3/18.
//  Copyright © 2018 William Becker. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       let newItem = Item()
        newItem.title = "Find Mike"
       
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Learn something"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Learn something else"
        itemArray.append(newItem3)
        
        
        
        if let items = userDefaults.array(forKey: "ToDoListArray") as? [Item] {
           itemArray = items
       }
        
        
    }

   //MARK - Table data source methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
       
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //Mark - Ternary operator
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        
        
        return cell
    }
    
    //MARK - Tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        
        
       tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    //MARK - add new item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen when item add button clicked
            
            let newItem = Item()
            newItem.title = textField.text!
            
            
            
            
            self.itemArray.append(newItem)
            
            self.userDefaults.set(self.itemArray, forKey: "ToDoListArray")
           
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
           alertTextField.placeholder = "Create New Item"
           
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    

}

