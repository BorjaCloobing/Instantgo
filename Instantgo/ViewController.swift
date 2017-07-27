//
//  ViewController.swift
//  Instantgo
//
//  Created by Borja Rodriguez Sánchez on 25/7/17.
//  Copyright © 2017 Borja Rodriguez Sánchez. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    /// Método para loggear al usuario en caso de tener cuenta ya creada
    ///
    /// - Parameter sender: button
    @IBAction func login(_ sender: Any) {
        
        if (emailTextfield.text != "") && (passwordTextfield.text != ""){
            FIRAuth.auth()?.signIn(withEmail: emailTextfield.text!, password: passwordTextfield.text!, completion: { (user, error) in
                if user != nil{
                    print("Success")
                    self.performSegue(withIdentifier: "calendar", sender: self)
                    self.showAlert(message: "Login correctly")
                }else{
                    if let myError = error?.localizedDescription{
                        self.showAlert(message: myError)
                    }else{
                        print("ERROR")
                    }
                    
                }
            })
            
        }else{
            //Muestra alerta faltan campos
            showAlert(message: "Textfields cannot be empty")
        }
    }
    
    
    /// Mensaje de alerta
    ///
    /// - Parameter message: Nos muestra si se ha loggeado con éxito o el tipo de error que ha provocado el log in
    public func showAlert(message: String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}

