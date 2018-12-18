//
//  ViewController.swift
//  Todoey
//
//  Created by DAVID BARLOW on 12/10/18.
//  Copyright © 2018 DAVID BARLOW. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {

    var todoItems : Results<Item>?
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
//
        tableView.separatorStyle = .none
        //with: request
        loadItems()
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        title = selectedCategory?.name
        
        guard let colorHex = selectedCategory?.color else {fatalError()}
        
        updateNavBar(withHexCode: colorHex)
    }
    
    override func willMove(toParent parent: UIViewController?) {
        
       
       updateNavBar(withHexCode: "1D9BF6")
    }
    
    //MARK: - Nav Bar Setup Methods
    func updateNavBar(withHexCode colorHexCode: String){
        
        guard let navBar = navigationController?.navigationBar else
        {fatalError("Navigation controller does not exist.")}
       
        guard let navBarColor = UIColor(hexString: colorHexCode) else {fatalError()}
        
        navBar.barTintColor = navBarColor
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
        
        searchBar.barTintColor = navBarColor
        
        
    }

    //MARK: - tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //optional chaining
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
       
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
//            let categoryColor = UIColor(hexString: selectedCategory?.color ?? "1D9BF6")
//
//            if let color = categoryColor!.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)){
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)){
                  cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
            
            
          
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No Items Added"
        }
        
        
        return cell
    }
    
    //MARK: - TableView Delegate methods
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        //instead of if then statement
        
        if let item = todoItems?[indexPath.row]{
            do {
                try realm.write{
                    item.done = !item.done
                }
            }catch{
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
//        todoItems[indexPath.row].done = !todoItems[indexPath.row].done
//
//        saveItems()
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the add item button on our UIAlert
            
            //create and save new item
print("let action")
            
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write{
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                }
            catch{
                print("Error saving context \(error)")
            }

            print("reload")
                self.tableView.reloadData()
            
        }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
       
        self.present(alert, animated: true, completion: nil)
    
        
    }
    
    //MARK: - Model Manipulation Methods
//    func saveItems(){
//
//        do {
//         try context.save()
//        } catch{
//            print("Error saving context \(error)")
//        }
//
//        self.tableView.reloadData()
//    }
    
    func loadItems() {

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    //MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = self.todoItems?[indexPath.row]{
                do {
                    try self.realm.write {
                        self.realm.delete(itemForDeletion)
                    }
                } catch {
                    print("Error deleting category, \(error)")
                }
        }
        
    }
    
    

}

//MARK: Search bar methods
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

       todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()


    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

        //get main thread and run searchbar resign.

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
}

