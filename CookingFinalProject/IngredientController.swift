//
//  IngredientController.swift
//  CookingFinalProject
//
//  Created by Grace Chen on 2022-07-19.
//

import Foundation
import UIKit

class IngredientController: UIViewController {
    
    @IBOutlet var ingredientOne: UITextField!
    @IBOutlet var ingredientTwo: UITextField!
    @IBOutlet var ingredientThree: UITextField!
    @IBOutlet var ingredientFour: UITextField!
    @IBOutlet var ingredientFive: UITextField!
    @IBOutlet var content: UIView!
    @IBOutlet var scroll: UIScrollView!
    @IBOutlet var button: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.content.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        //self.content.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor).isActive = true
        
        self.scroll.contentSize = content.frame.size
        
        Utilities.styleFilledButton(self.button)
        
        self.hideKeyboardWhenTappedAround()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let secondViewController = segue.destination as! ViewController
        
        secondViewController.selectedIngredients.append(ingredientOne.text!)
        secondViewController.selectedIngredients.append(ingredientTwo.text!)
        secondViewController.selectedIngredients.append(ingredientThree.text!)
        secondViewController.selectedIngredients.append(ingredientFour.text!)
        secondViewController.selectedIngredients.append(ingredientFive.text!)
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
