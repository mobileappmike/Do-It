//
//  SwipeTableViewController.swift
//  Do It
//
//  Created by Michael Miles on 12/15/18.
//  Copyright © 2018 Michael Miles. All rights reserved.
//


// This class will be subclassed out to category and todolist VC's because they require the same deleting function, but I didn't want to repeat myself.

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        //make identifier more common 'Cell' so that you can apply it to both cells in the storyboard.
        
        cell.delegate = self
        
        return cell
    }

    //MARK: Swipe Cell Delegate Methods
        func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
            
            guard orientation == .right else { return nil }
            
            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                // handle action by updating model with deletion
                
                print("Delete Cell")
                
                self.updateModel(at: indexPath)
            }
            
            // customize the action appearance
            deleteAction.image = UIImage(named: "Trash")
            
            return [deleteAction]
            
        }
        
        func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
            var options = SwipeOptions()
            options.expansionStyle = .destructive
            return options
        }
    
    func updateModel(at indexPath: IndexPath) {
        //this is where the data model is updated
    }
    
}
