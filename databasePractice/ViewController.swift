//
//  ViewController.swift
//  databasePractice
//
//  Created by William Keeley on 11/18/20.
//  Copyright © 2020 CamKeeleyApps. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var db:SQLiteDatabase = SQLiteDatabase()
    
    var mural1 = Mural(id: 1, xLocation: 32, yLocation: 67, name: "chicano art", artist: "chicano artist", description: "pretty painting", historicalContext: "interesting story")
    
    
 /*
    struct Mural {
        let id: Int32
        let xLocation: Int32
        let yLocation: Int32
        let name: NSString
        let artist: NSString
        let description: NSString
        let historicalContext: NSString
    }
*/
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        do{
         
            
            
          try db.insertIntoTable(mural: mural1)
        } catch {
            print("Failed to call insertMural function from viewDidLoad function")
        }
        
        
        
        
       
        
    }


}

