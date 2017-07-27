//
//  SignInViewController.swift
//  Instantgo
//
//  Created by Borja Rodriguez Sánchez on 25/7/17.
//  Copyright © 2017 Borja Rodriguez Sánchez. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var signUp: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /// Crea un nuevo usuario en nuestra DB Firebase Auth
    ///
    /// - Parameter sender: button
    @IBAction func signUp(_ sender: Any) {
        if (emailTextfield.text != "") && (passwordTextfield.text != ""){
            FIRAuth.auth()?.createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!, completion: { (user, error) in
                if user != nil{
                    print("Success")
                    self.performSegue(withIdentifier: "calendar", sender: self)
                    self.showAlert(message: "Sign Up correctly")
                }else{
                    if let myError = error?.localizedDescription{
                        print(myError)
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
    /// - Parameter message: Nos muestra si se ha registrado con éxito o el tipo de error que ha provocado el sign up
    public func showAlert(message: String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
