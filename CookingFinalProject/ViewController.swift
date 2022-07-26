//
//  ViewController.swift
//  CookingFinalProject
//
//  Created by Grace Chen on 2022-07-08.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var recipeNames: [String] = []
    var recipeImages: [String] = []
    var recipeMealTypes: [[String]] = []
    var recipeIngredientLines: [[String]] = []
    var selectedIngredients: [String] = []
    var instructionLinks: [String] = []
    var ingredientsPlusAmounts: [[String: Double]] = []
    var foodCautions: [[String]] = []
    
    @IBOutlet var tableView: UITableView!
    // @IBOutlet var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        var foods: [String] = []
        
        for ingredient in selectedIngredients {
            if ingredient != "" {
                foods.append(ingredient)
            }
        }
        
        getRecipes(foods: foods)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recipeNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let name = recipeNames[indexPath.row]
        
        cell.textLabel?.text = name
        print((recipeMealTypes[indexPath.row]).first!)
        cell.detailTextLabel?.text = (recipeMealTypes[indexPath.row]).first
        
        fetchImage(urlString: recipeImages[indexPath.row]) { (imageData) in
            if let data = imageData {
                DispatchQueue.main.async {
                    cell.imageView?.image = UIImage(data: data)
                    cell.layoutSubviews()
                }
            }
        }
        
        return cell
    }
    
    /*func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toDetailed", sender: self)
    }
    */
    
    /*@IBAction func searchPressed(_ sender: UIButton) {
        var foods: [String] = []
        
        for ingredient in selectedIngredients {
            if ingredient != "" {
                foods.append(ingredient)
            }
        }
        
        getRecipes(foods: foods)
        // print("I am here")
        // tableView.reloadData()
    }*/
    
    @IBAction func backPressed(_ sender: UIButton){
        dismiss(animated: true, completion: nil)
    }

    func getRecipes(foods: [String]){
        //var holder: String = ""
        var base = "https://api.edamam.com/search?q="
        for food in foods {
            base = base + (food + ",")
        }
        base = String(base.dropLast())
        base = base + "&app_id=69651308&app_key=7b9d423b27b3a4efcbd2ff7ec679ae99"
        
        
        let url = URL(string: base)!
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //let task = URLSession.shared.dataTask(with: url) { data, response, error in
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: []){
                    if let array = json as? [String: Any] {
                        if let hits = array["hits"] as? [Any] {
                            for hit in hits {
                                if let arr = hit as? [String: Any] {
                                    if let recipe = arr["recipe"] as? [String: Any] {
                                        print(recipe["label"]!)
                                        // holder = recipe["label"] as! String
                                        self.recipeNames.append(recipe["label"] as! String)
                                        self.recipeImages.append(recipe["image"] as! String)
                                        self.recipeMealTypes.append(recipe["mealType"] as! [String])
                                        self.recipeIngredientLines.append(recipe["ingredientLines"] as! [String])
                                        self.instructionLinks.append(recipe["url"] as! String)
                                        
                                        var holder: [String: Double] = [:]
                                        for ingredient in (recipe["ingredients"] as! [Any]) {
                                            let temp = ingredient as! [String: Any]
                                            holder[temp["food"] as! String] = (temp["quantity"] as! Double)
                                        }
                                        self.ingredientsPlusAmounts.append(holder)
                                        
                                        self.foodCautions.append(recipe["cautions"] as! [String])
                                                                                
                                    } else if let error = error {
                                        print("Recipe failed due to \(error)")
                                    }
                                } else if let error = error {
                                    print("Arr Request failed due to \(error)")
                                }
                            }
                        } else if let error = error {
                            print("Hits failed due to \(error)")
                        }
                    } else if let error = error {
                        print("Array failed due to \(error)")
                    }
                } else if let error = error {
                    print("JSON Request failed due to \(error)")
                }
            } else if let error = error {
                print("Data failed due to \(error)")
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }.resume()
        
        // task.resume()
        // self.recipeNames.append(holder)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let second = segue.destination as! RecipeDetailController
        if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
            
            //print(recipeImages[indexPath.row])
            //print(indexPath.row)
            
            second.nameHolder = recipeNames[indexPath.row]
            second.ingredientLines = recipeIngredientLines[indexPath.row]
            second.imageURL = recipeImages[indexPath.row]
            second.instructionURL = instructionLinks[indexPath.row]
            second.neededIngredients = ingredientsPlusAmounts[indexPath.row]
            second.cautions = foodCautions[indexPath.row]
        }
    }
}

func fetchImage(urlString: String, completionHandler: @escaping (_ data: Data?) -> ()) {
    let session = URLSession.shared
    let url = URL(string: urlString)
        
    let dataTask = session.dataTask(with: url!) { (data, response, error) in
        if error != nil {
            print("Error fetching the image!")
            completionHandler(nil)
        } else {
            completionHandler(data)
        }
    }
        
    dataTask.resume()
}
