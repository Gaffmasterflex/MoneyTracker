//
//  ItemViewController.swift
//  MoneyTracker
//
//  Created by Dean Gaffney on 26/11/2016.
//  Copyright © 2016 Dean Gaffney. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController ,UITextFieldDelegate{

    @IBOutlet weak var canelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var costTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    
    var item: Item?
    var tracker: Tracker?
    
    var backgroundImage = UIImageView(frame: UIScreen.main.bounds)
    
        
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Home"
        backgroundImage.image = UIImage(named: Bundle.main.path(forResource: "moneytracker-02",ofType: ".png")!)
        self.view.insertSubview(backgroundImage, at: 0)
        
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

       //set up text field delegates
        nameTextField.delegate = self
        categoryTextField.delegate = self
        costTextField.delegate = self
        dateTextField.delegate = self
        
        if let item = item{
            navigationItem.title = item.name
            nameTextField.text = item.name
            categoryTextField.text = String(format:"%d",item.category)
            costTextField.text = String(format: "%.2f",item.cost)
            dateTextField.text = String(format: "%d/%d/%d", item.purchaseDay,item.purchaseMonth,item.purchaseYear)
        }
        
        var seguedTracker = tracker{
            didSet{
                tracker = seguedTracker
            }
        }
        //set up date text field automatically
        let formatter = DateFormatter()
        let date = Date()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        let formattedDate = formatter.string(from: date)
        let dateComponents = formattedDate.components(separatedBy: "/")
        print(dateComponents)
        dateTextField.text =
            String(format: "%d/%d/%d",dateComponents[1],dateComponents[0],dateComponents[2])
        //enable save button only if field is not empty
        saveButton.isEnabled = (isAllFieldsFilled()) ? true : false

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
      //  saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        navigationItem.title = nameTextField.text
        saveButton.isEnabled = (isAllFieldsFilled()) ? true : false
    }
    
    //checks if all fields are filled in
    func isAllFieldsFilled()->Bool{
        return !(nameTextField.text?.isEmpty)! &&
               !(categoryTextField.text?.isEmpty)! &&
               !(dateTextField.text?.isEmpty)! &&
               !(costTextField.text?.isEmpty)!
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (sender as! UIBarButtonItem === saveButton){
            // initalise properties of the object
            let name = nameTextField.text ?? ""
            let cost = costTextField.text ?? "0.0"
           // let category = convertCategory(value: categoryTextField.text!)
            let category = 1
            item = CoreDataController.createNewItem(name: name, cost: Double(cost)!, purchaseDate: Date(),category: Int32(category),owningTracker: tracker!)
        }
    }
    
    //gets item category from textview and converst to Item Category enum
   /* func convertCategory(value: String)->Item.Category{
        if(value.lowercased() == "food"){
            return Item.Category.FOOD
        }else if(value.lowercased() == "car"){
            return Item.Category.CAR
        }else if(value.lowercased() == "drink"){
            return Item.Category.DRINK
        }else if(value.lowercased() == "bill"){
            return Item.Category.CAR
        }
        return Item.Category.MISC
    }*/
    
    //on cancel button pressed
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isPresentingInAddItemMode = presentingViewController is UINavigationController
        if isPresentingInAddItemMode{
            dismiss(animated: true, completion: nil)
        }else{
            navigationController!.popViewController(animated: true)
        }
    }
       

}
