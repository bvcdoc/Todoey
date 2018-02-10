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
    
   let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.")
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        print(dataFilePath )
        
       
       loadItems()
        
        
       // if let items = userDefaults.array(forKey: "ToDoListArray") as? [Item] {
        //   itemArray = items
     //  }
        
        
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
        
        self.saveItems()
        
      
        
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
            
           self.saveItems()
            
            
        }
        
        alert.addTextField { (alertTextField) in
           alertTextField.placeholder = "Create New Item"
           
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
   // MARK - Model manipulation methods
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try  data.write(to: dataFilePath!)
            
        } catch {
            print("Error encoding item array, \(error)")
        }
        
        self.tableView.reloadData()
    }
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do { itemArray = try decoder.decode([Item].self, from: data)}
            catch {
                print("Error decoding item array, \(error)")
            }
        }
        
        
    }

}

