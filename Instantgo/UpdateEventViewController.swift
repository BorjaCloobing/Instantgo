//
//  UpdateEventViewController.swift
//  Instantgo
//
//  Created by Borja Rodriguez Sánchez on 26/7/17.
//  Copyright © 2017 Borja Rodriguez Sánchez. All rights reserved.
//

import UIKit
import FirebaseDatabase
import EventKit

class UpdateEventViewController: UIViewController {
    @IBOutlet weak var titleTextfield: UITextField!
    @IBOutlet weak var dateTextfield: UITextField!
    @IBOutlet weak var hourTextfield: UITextField!
    
    //Guardo la referencia a la DB en una variable
    let databaseRef = FIRDatabase.database().reference().child("Events")
    //Guardo el id del evento para que cuando quiera eliminarlo del calendario del terminal no perder la referencia de este
    var savedEventId : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Guardo el id del evento, para que cuando lo añada el calendario del terminal tenga una referencia de este, por si posteriormente quiero eliminarlo.
       
        //Actualizo lo campos de este VC con los que manda el VC Calendar para su posterior edición
        titleTextfield.text = events[myIndex].title
        dateTextfield.text = events[myIndex].date
        hourTextfield.text = events[myIndex].hour

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /// Método para actualizar el evento en DB y mostrar un mensaje con
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func updateEvent(_ sender: Any) {
        let id = events[myIndex].id!
        
        let event : [String : AnyObject] = ["id" : id as AnyObject ,
                                            "title" : titleTextfield.text as AnyObject,
                                            "date" : dateTextfield.text as AnyObject,
                                            "hour" : hourTextfield.text as AnyObject]
       
        databaseRef.child(id).setValue(event)
        
        showAlert(message: "Event has been uploaded successfully")


    }
    
    
    /// Método para añadir pedir permisos al usuario de acceso al calendario y llamar a la función que añada dicho evento, en este caso le asigno el nombre del evento, y le fijo la hora actual y duración una hora
    ///
    /// - Parameter sender: button
    @IBAction func addPhoneCalendar(_ sender: Any) {
        let eventStore = EKEventStore()
        
        let startDate = NSDate()
        let endDate = startDate.addingTimeInterval(60 * 60) // One hour
        
        if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
            eventStore.requestAccess(to: .event, completion: {
                granted, error in
                self.createEvent(eventStore: eventStore, title: events[myIndex].title, startDate: startDate, endDate: endDate)
            })
        } else {
            createEvent(eventStore: eventStore, title: events[myIndex].title, startDate: startDate, endDate: endDate)
        }
        showAlert(message: "Event has been added successfully to your calendar")

    }

    /// Método para añadir el evento al calendario
    ///
    /// - Parameters:
    ///   - eventStore: evenStore
    ///   - title: título del evento
    ///   - startDate: hora actual
    ///   - endDate: duración 1 hora
    func createEvent(eventStore: EKEventStore, title: String, startDate: NSDate, endDate: NSDate) {
        let event = EKEvent(eventStore: eventStore)
        
        event.title = title
        event.startDate = startDate as Date
        event.endDate = endDate as Date
        event.calendar = eventStore.defaultCalendarForNewEvents
        do {
            try eventStore.save(event, span: .thisEvent)
            savedEventId = event.eventIdentifier
        } catch {
            print("No se ha podido añadir el evento al calendario")
        }
            }
    
    /// Pido permisos para acceder al calendario y llamo a la función borrar evento
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func deletePhoneCalendar(_ sender: Any) {
        let eventStore = EKEventStore()
        
        if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
            eventStore.requestAccess(to: .event, completion: { (granted, error) -> Void in
                self.deleteEvent(eventStore: eventStore, eventIdentifier: self.savedEventId)
            })
        } else {
            deleteEvent(eventStore: eventStore, eventIdentifier: savedEventId)
        }
        showAlert(message: "Event has been deleted from your calendar")

    }
    
    /// Borrar el evento del calendario
    ///
    /// - Parameters:
    ///   - eventStore: evenStore
    ///   - eventIdentifier: el id que guardé al añadir el evento al calendario
    func deleteEvent(eventStore: EKEventStore, eventIdentifier: String) {
        let eventToRemove = eventStore.event(withIdentifier: eventIdentifier)
        if (eventToRemove != nil) {
            do {
                try eventStore.remove(eventToRemove!, span: .thisEvent)
            } catch {
                print("No se ha podido eliminar el evento del calendario")
            }
        }
    }

    public func showAlert(message: String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
