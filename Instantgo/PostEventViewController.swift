//
//  PostEventViewController.swift
//  Instantgo
//
//  Created by Borja Rodriguez Sánchez on 26/7/17.
//  Copyright © 2017 Borja Rodriguez Sánchez. All rights reserved.
//

import UIKit
import FirebaseDatabase

class PostEventViewController: UIViewController {

    @IBOutlet weak var titleTextfield: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var hourTextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /// Método para añadir nuevos eventos a mi lista de eventos 
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func postEvent(_ sender: Any) {
        
        let title = titleTextfield.text
        let date = dateTextField.text
        let hour = hourTextfield.text
        let databaseRef = FIRDatabase.database().reference().child("Events")
        let key = databaseRef.childByAutoId().key
        
        let event : [String : AnyObject] = ["id" : key as AnyObject ,
                                            "title" : title as AnyObject,
                                            "date" : date as AnyObject,
                                            "hour" :hour as AnyObject]
        
        databaseRef.child(key).setValue(event)
        self.performSegue(withIdentifier: "calendar", sender: self)
    }

}
