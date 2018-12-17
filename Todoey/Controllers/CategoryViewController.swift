//
//  CategoryTableTableViewController.swift
//  Todoey
//
//  Created by DAVID BARLOW on 12/12/18.
//  Copyright © 2018 DAVID BARLOW. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    //FYI categories is categoryArray renamed
    let realm = try! Realm()
    //Thread 1: Fatal error: 'try!' expression unexpectedly raised an error: Error Domain=io.realm Code=5 "Directory at path '/Users/davidrbarlow/Library/Developer/CoreSimulator/Devices/6CC69280-F7CD-4748-85F4-B7D453BC9F16/data/Containers/Data/Application/C651114B-B829-44B2-A211-C95D8163DE55/Documents/default.realm' does not exist." UserInfo={Error Code=5, NSFilePath=/Users/davidrbarlow/Library/Developer/CoreSimulator/Devices/6CC69280-F7CD-4748-85F4-B7D453BC9F16/data/Containers/Data/Application/C651114B-B829-44B2-A211-C95
    
    var categories: Results<Category>?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
       
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //nil coellace operator
        // if categories is not nill return count else 1
        return categories?.count  ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories added yet"
        
        return cell
    }
    

    
    
    
    //MARK: - Add New Categories

   
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {

        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            //what will happen once the user clicks the add item button on our UIAlert
            
            
            let newCategory = Category()
            newCategory.name = textField.text!
         
            self.save(category: newCategory)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)

        
        
    }
    
    //MARK: - TableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "gotoItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
    
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    
    }
    //MARK: - Data Maniputlation Methods
    
    func save(category: Category){
        
        do {
            try realm.write{
             realm.add(category)
            }
        } catch{
            print("Error saving context \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories() {

        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
}

extension CategoryViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request : NSFetchRequest<Category> = Category.fetchRequest()
//
//        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
//
//        loadCategories(with: request)
       
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
           // loadCategories()
            
            //get main thread and run searchbar resign.
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}
