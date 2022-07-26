//
//  AddFoodController.swift
//  CookingFinalProject
//
//  Created by Grace Chen on 2022-07-13.
//

import CoreData
import UIKit

class AddFoodController: UIViewController {
    
    @IBOutlet var foodName: UITextField!
    @IBOutlet var amountChanger: UIStepper!
    @IBOutlet var amount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        amountChanger.minimumValue = 1
    }
    
    @IBAction func stepperClicked(_ sender: UIStepper){
        amount.text = Int(sender.value).description
    }
    
    @IBAction func confirmTapped(_ sender: UIBarButtonItem){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newItem = Food(context: context)
        
        newItem.amount = amount.text
        newItem.name = foodName.text
        newItem.identifier = UUID().uuidString
        
        do {
            try context.save()
        } catch let error {
            print("Could not save because of \(error)")
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelTapped(_ sender: UIBarButtonItem){
        dismiss(animated: true, completion: nil)
    }
}
