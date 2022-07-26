//
//  HelpController.swift
//  CookingFinalProject
//
//  Created by Grace Chen on 2022-07-23.
//

import Foundation
import UIKit

class HelpController: UIViewController {

    @IBOutlet var partOne: UILabel!
    @IBOutlet var partTwo: UILabel!
    @IBOutlet var partThree: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.partOne.lineBreakMode = .byWordWrapping
        self.partOne.numberOfLines = 0
        self.partOne.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -40).isActive = true
        
        self.partTwo.lineBreakMode = .byWordWrapping
        self.partTwo.numberOfLines = 0
        self.partTwo.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -40).isActive = true
        
        self.partThree.lineBreakMode = .byWordWrapping
        self.partThree.numberOfLines = 0
        self.partThree.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -40).isActive = true
        
        self.partOne.text = "For the Recipe Search, enter the specific ingredients that you want into the text fields (like the one seen below) and hit Search!"
        self.partTwo.text = "Just wait a little bit and the recipes will soon appear! If you want to know more any specific recipe, just click on it and it will show the ingredients, what you are missing in your Fridge and where to find the instructions."
        self.partThree.text = "To update your Fridge, just switch to the tab and click the plus icon in the top right to quickly add a new ingredient. If you need to remove anything, just swipe right and delete button will appear!"
        
        self.hideKeyboardWhenTappedAround()
    }
}
