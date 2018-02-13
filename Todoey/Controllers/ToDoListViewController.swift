//
//  ViewController.swift
//  Todoey
//
//  Created by William Becker on 2/3/18.
//  Copyright © 2018 William Becker. All rights reserved.
//

import UIKit
import  CoreData

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    let request : NSFetchRequest<Item> = Item.fetchRequest()
   
    
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.") as Any)
        
      //  searchBar.delegate = self
        
      //// moved up let request : NSFetchRequest<Item> = Item.fetchRequest()
       
        loadItems(request: request)
        
        
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
        
    //    context.delete(itemArray[indexPath.row])
    //    itemArray.remove(at: indexPath.row)
       
        ////here
        //itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        self.saveItems()
        
      
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    //MARK - add new item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen when item add button clicked
            
            
           
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            
            
            
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
       
        
        do {
           try context.save()
            
        } catch {
           print("error saving context. \(error)")
        }
        
        self.tableView.reloadData()
    }
    func loadItems(request: NSFetchRequest<Item>){
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArray = try context.fetch(request)
        } catch{
            print("Error fetching data, \(error)")
        }
        tableView.reloadData()
    }
    
    
}
//MARK: Search Bar Methods

extension ToDoListViewController: UISearchBarDelegate {

func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    let  request : NSFetchRequest<Item> = Item.fetchRequest()
    
    let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
    
    request.predicate = predicate
    
    let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
    
    request.sortDescriptors = [sortDescriptor]
    
    loadItems(request: request)
    do {
        itemArray = try context.fetch(request)
    } catch{
        print("Error fetching data, \(error)")
    }
    tableView.reloadData()

    
}
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
          loadItems(request: request)
            
            tableView.reloadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            searchBar.resignFirstResponder()
        }
    }



}


