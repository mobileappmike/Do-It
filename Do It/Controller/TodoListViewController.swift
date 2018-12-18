//
//  ViewController.swift
//  Do It
//
//  Created by Michael Miles on 11/19/18.
//  Copyright © 2018 Michael Miles. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    var todoItems : Results<Item>?
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    //created for segue from categories...using didSet makes sure that we have a value for category before we request loading the items
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
//    create filepath to documents folder
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    //this is how to tap into another class and cast it. context = data purgatory
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        
    }
    
    //this function is after everything is loaded...RIGHT before user views the screen. Navcontroller doesn't work in viewDidLoad bc it isn't loaded yet
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory?.name
        guard let colorHex = selectedCategory?.color else { fatalError() }
        updateNavBar(withHexCode: colorHex)
    }

    //becomes active when user is closing out this view
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "1D9BF6")
    }
    
    //MARK: Nav Bar Setup Methods
    func updateNavBar(withHexCode colorHexCode : String) {
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Navigation Controller does not exist.")
        }
        
        //this GUARD LET with a fatal error is useful when adding new features and testing
        //GUARD is the best to use if you're using IF LET without the ELSE in it

        guard let navBarColor = UIColor(hexString: colorHexCode) else { fatalError() }
        
        navBar.barTintColor = navBarColor
        
        searchBar.barTintColor = navBarColor
        
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        
        //must use largetitletext bc we're using large titles
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
        
    }

    //MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            let categoryColor = UIColor.init(hexString: selectedCategory!.color)
            
            //MUST convert both sides of equation to CGFloats BEFORE dividing
            if let color = categoryColor!.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
            print("version 1: \(CGFloat(indexPath.row / todoItems!.count))")
            print("version 2: \(CGFloat(indexPath.row) / CGFloat(todoItems!.count))")
            
            //ternary operator
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        

        
        return cell
    }
    
    
    //MARK: TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
            try realm.write {
                item.done = !item.done
            }
            } catch {
                print("Error saving done status \(error)")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New To Do Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                let newItem = Item()
                newItem.title = textField.text!
                newItem.dateCreated = Date()
                currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new Items, \(error)")
                }
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: Model Manipulation
    
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    //MARK: Delete Data from Swipe
    //this is how to override a function in a superclass
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            } catch {
                print("error deleting item, \(error)")
            }
        }
    }
    
}
    
    //MARK: Search Bar Extension
    extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            //this function puts the searchBar in the main queue, so that you can tell it to stop the process
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
