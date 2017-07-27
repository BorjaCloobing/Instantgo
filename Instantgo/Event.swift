//
//  Event.swift
//  Instantgo
//
//  Created by Borja Rodriguez Sánchez on 27/7/17.
//  Copyright © 2017 Borja Rodriguez Sánchez. All rights reserved.
//

import UIKit

class Event: NSObject {
    var id = String()
    var title = String()
    var date = String()
    var hour = String()
   
    
    
    
    init(id : String, title: String,date : String, hour : String) {
        self.id = id
        self.title = title
        self.date = date
        self.hour = hour
    }
    

}
