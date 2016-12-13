//
//  ViewController.swift
//  TODOLister
//
//  Created by Volodymyr Lavryk on 12.12.16.
//  Copyright © 2016 Volodymyr Lavryk. All rights reserved.
// ✅

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    
    //outlets and actions
    
    @IBOutlet weak var sortBarButton: UIBarButtonItem!
    
    @IBAction func sortByAlphabet(_ sender: UIBarButtonItem) {
        func sortWith(items: [ChecklistItem]) -> [ChecklistItem] {
            var sortedItems = [ChecklistItem]()
            sortedItems = items.sorted(by: {$0.text.characters.first! < $1.text.characters.first!})
            
            return sortedItems
        }
        items = sortWith(items: items)
        
        print( items)
        tableView.reloadData()
        sortBarButton.isEnabled = false  //TODO
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
    //items for tests
    
    var items: [ChecklistItem]
    
    required init?(coder aDecoder: NSCoder) {
        items = [ChecklistItem]()
        super.init(coder: aDecoder)
        loadChecklistItems()
    }
    
    
    // prerape for delegate beetwen two views
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = items[indexPath.row]
            }
        }
    }
    
    // add TODO tast to list
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) { // if add new item
        let newRowIndex = items.count
        items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        dismiss(animated: true, completion: nil)
        sortBarButton.isEnabled = true
         saveToDolistItems()
    }
    
    
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) { //if edit item
        if let index = items.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        sortBarButton.isEnabled = true
        dismiss(animated: true, completion: nil)
         saveToDolistItems()
    }
    
    
    
    // cancel
    
    func itemDetailViewControllerDidCancel(
        _ controller: ItemDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    // numbers of rows in section
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    
    
    // cell for row
    
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ChecklistItem", for: indexPath)
        let item = items[indexPath.row]
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        return cell
        
        
    }
    
    // toggle check status
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = items[indexPath.row]
            item.toggleChecked()
            configureCheckmark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        saveToDolistItems()
    }
    
    
    // checkmark configure
    
    func configureCheckmark(for cell: UITableViewCell,
                            with item: ChecklistItem) {
        let label = cell.viewWithTag(1001) as! UILabel
        if item.checked {
            label.text = "✅"
        } else {
            label.text = "❌"
        }
    }
    
    
    // remove item from list
    
    override func  tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        items.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        sortBarButton.isEnabled = true
        saveToDolistItems()
    }
    
    
    
    // text of TODO task
    func configureText(for cell: UITableViewCell,
                       with item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    
    
    //directory for save items
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
            return paths[0]
        }
        func dataFilePath() -> URL {
            return documentsDirectory().appendingPathComponent("TODOLister.plist")
        }
    
    // save function
    
    func saveToDolistItems() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(items, forKey: "ChecklistItems")
        archiver.finishEncoding()
        data.write(to: dataFilePath(), atomically: true)
    }
        
   // load from memmory
    
    
    func loadChecklistItems(){
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            items = unarchiver.decodeObject(forKey: "ChecklistItems") as! [ChecklistItem]
            unarchiver.finishDecoding()
        }
    }
        
        
        
        
}
