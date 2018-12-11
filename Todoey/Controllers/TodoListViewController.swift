//
//  ViewController.swift
//  Todoey
//
//  Created by DAVID BARLOW on 12/10/18.
//  Copyright © 2018 DAVID BARLOW. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
   
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(itemArray.count)
        
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Buy Eggos"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Destroy Demogorgon"
        itemArray.append(newItem3)
        
    
        
//        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
//            itemArray = items
//        }
        
    }

    //MARK - tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
       
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        // Ternary operator
        //value = condition ? valueIfTrue : valueIfFalse
        
        //        if item.done == true{
        //            cell.accessoryType = .checkmark
        //        } else {
        //            cell.accessoryType = .none
        //        }
        
        
        // cell.accessoryType = item.done == true ? .checkmark : .none
       
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        return cell
    }
    
    //MARK - TableView Delegate methods
        //THis is my answer
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath)
//        let text : String = String(cell!.textLabel!.text!)
//        if cell!.textLabel != nil && cell!.textLabel!.text!.range(of: "✓") == nil {
//            print(text)
//            cell!.textLabel?.text = "\(text) ✓"
//        } else if cell!.textLabel != nil && cell!.textLabel!.text!.range(of: "✓") != nil {
//            print(text)
//            cell!.textLabel?.text = text.replacingOccurrences(of: "✓", with: "")
//        }
//
//    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
       
        //instead of if then statement
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
//
        
        //calls data source methods again
        tableView.reloadData()
        
//        old code before Model
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MATK - Add New Items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the add item button on our UIAlert
            
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
            self.defaults.set(self.itemArray, forKey: "TodoListArray");
            
            self.tableView.reloadData()
        }
    
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
}


