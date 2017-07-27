//
//  CalendarViewController.swift
//  Instantgo
//
//  Created by Borja Rodriguez Sánchez on 25/7/17.
//  Copyright © 2017 Borja Rodriguez Sánchez. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

struct  event {
    let id : String!
    let title : String!
    let date : String!
    let hour : String!
}

//Array de eventos para almacenar los eventos según los parsee de la BD
var events = [event]()
//Indice para saber que celda pinché e instanciar a dicho evento
var myIndex = 0;
let databaseRef = FIRDatabase.database().reference()
class CalendarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logINemailTextfield: UILabel!
  
    @IBOutlet weak var logOut: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logINemailTextfield.text = FIRAuth.auth()?.currentUser?.email
       
    }
    
    
    /// Método que consulta la base de datos Eventos y la inserta en nuestro array de eventos para posteriormente mostrarlos en el tableview
    ///
    /// - Parameter animated: <#animated description#>
    override func viewWillAppear(_ animated: Bool) {
        

        databaseRef.child("Events").queryOrderedByKey().observe(.childAdded, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let key = value?["id"] as! String
            let title = value?["title"] as! String
            let date = value?["date"] as! String
            let hour = value?["hour"]  as! String
            
            events.insert(event(id: key, title : title, date: date, hour: hour), at: 0)
            self.tableView.reloadData()
        })
        
        //Elimino los elementos del array para que no me coja duplicados la próxima vez que carguemos los datos de la DB
        events.removeAll()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return events.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       // let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell" , forIndexPath: indexPath) as! UITableViewCell
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let titleLabel = cell.viewWithTag(1) as! UILabel
        titleLabel.text = events[indexPath.row].title
        let dateLabel = cell.viewWithTag(2) as! UILabel
        dateLabel.text = events[indexPath.row].date
        let hourLabel = cell.viewWithTag(3) as! UILabel
        hourLabel.text = events[indexPath.row].hour
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        self.performSegue(withIdentifier: "update", sender: tableView)

    }
    
    
    @IBAction func logOut(_ sender: Any) {
        
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "login", sender: self)
    }
   
    
    
}
