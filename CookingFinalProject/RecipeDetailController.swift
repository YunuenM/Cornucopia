//
//  RecipeDetailController.swift
//  CookingFinalProject
//
//  Created by Grace Chen on 2022-07-20.
//

import Foundation
import UIKit
import CoreData

class RecipeDetailController: UIViewController {
    
    @IBOutlet var name: UILabel!
    @IBOutlet var ingredients: UILabel!
    @IBOutlet var image: UIImageView!
    @IBOutlet var missing: UILabel!
    @IBOutlet var scroll: UIScrollView!
    @IBOutlet var content: UIStackView!
    @IBOutlet var warnings: UILabel!
    
    var nameHolder: String = ""
    var imageURL: String = ""
    var ingredientLines: [String] = []
    var instructionURL: String = ""
    var neededIngredients: [String: Double] = [:]
    var missingIngredients: String = ""
    var cautions: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.name.text = nameHolder
        self.name.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -20).isActive = true
        self.name.lineBreakMode = .byWordWrapping
        self.name.numberOfLines = 0
        
        // print(imageHolder!)
        
        fetchImage(urlString: imageURL) { (imageData) in
            if let data = imageData {
                DispatchQueue.main.async {
                    self.image.image = UIImage(data: data)
                }
            }
        }
        // self.image.layoutSubviews()
        
        self.ingredients.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -20).isActive = true
        self.ingredients.lineBreakMode = .byWordWrapping
        self.ingredients.numberOfLines = 0
        
        let top = NSMutableAttributedString(string: "Ingredients\n\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17)])
        var temp: String = ""
        for ingredientLine in ingredientLines {
            temp = temp + ingredientLine + "\n"
        }
        
        top.append(NSMutableAttributedString(string: temp))
        
        self.ingredients.attributedText = top
        self.ingredients.sizeToFit()
        
        self.missing.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -20).isActive = true
        self.missing.lineBreakMode = .byWordWrapping
        self.missing.numberOfLines = 0
        self.findAndCompareFoods()
        
        let bolded = NSMutableAttributedString(string: "Missing Ingredients from Fridge\n\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17)])
        bolded.append(NSMutableAttributedString(string: missingIngredients))
        self.missing.attributedText = bolded
        self.missing.sizeToFit()
        
        self.warnings.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -20).isActive = true
        self.warnings.lineBreakMode = .byWordWrapping
        self.warnings.numberOfLines = 0
        
        let warningTitle = NSMutableAttributedString(string: "Warnings & Cautions\n\n", attributes: [NSMutableAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17)])
        var body = ""
        if cautions.count > 0 {
            body = cautions[0]
            for caution in cautions {
                if caution != cautions[0] {
                    body = body + ", " + caution
                }
            }
            body += "\n"
        } else {
            body = "None\n"
        }
        
        warningTitle.append(NSMutableAttributedString(string: body))
        self.warnings.attributedText = warningTitle
        
        self.image.enableZoom()
        scroll.contentSize = content.frame.size
    }
    
    @IBAction func instructionPressed(_ sender: UIButton) {
        if let url = URL(string: instructionURL) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func findAndCompareFoods() {
        var foods: [Food] = []
        var found: [String] = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = Food.fetchRequest() as NSFetchRequest<Food>
        
        do {
            foods = try context.fetch(fetchRequest)
        } catch let error {
            print("Can't fetch because of \(error)")
        }
        
        for key in neededIngredients.keys {
            for food in foods {
                if (key.lowercased()).contains((food.name!).lowercased()){
                    if let number = Double(food.amount!){
                        if number >= neededIngredients[key]! {
                            print("Found it! " + (food.name!))
                            found.append(key)
                            break
                        }
                    }
                }
            }
        }
        
        for key in neededIngredients.keys {
            if found.contains(key) == false {
                missingIngredients = missingIngredients + key + "\n"
            }
        }
    }
}

extension UIImageView {
  func enableZoom() {
    let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(startZooming(_:)))
    isUserInteractionEnabled = true
    addGestureRecognizer(pinchGesture)
  }

  @objc
  private func startZooming(_ sender: UIPinchGestureRecognizer) {
    let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
    guard let scale = scaleResult, scale.a > 1, scale.d > 1 else { return }
    sender.view?.transform = scale
    sender.scale = 1
  }
}
