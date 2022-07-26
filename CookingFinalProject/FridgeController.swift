//
//  FridgeController.swift
//  CookingFinalProject
//
//  Created by Grace Chen on 2022-07-22.
//

import CoreData
import UIKit

class FridgeController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var foods = [Food]()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = Food.fetchRequest() as NSFetchRequest<Food>
        do {
            foods = try context.fetch(fetchRequest)
        } catch let error {
            print("Could not fetch because of \(error)")
        }
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "fridgeCellIdentifier", for: indexPath)
        
        cell.textLabel?.text = foods[indexPath.row].name
        cell.detailTextLabel?.text = foods[indexPath.row].amount
        
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if foods.count > indexPath.row {
            let food = foods[indexPath.row]
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            context.delete(food)
            foods.remove(at: indexPath.row)
            do {
                try context.save()
            } catch let error {
                print("Cannot delete because of \(error)")
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
