//
//  SQLiteDatabase.swift
//  databasePractice
//
//  Created by Cameron Keeley on 11/19/20.
//  Copyright © 2020 CamKeeleyApps. All rights reserved.
//

import SQLite3
import Foundation

/*
 enum containing different error messages which can occur when issuing sqlite commands
 */
enum SQLiteErrorMessages: Error {
    case OpenDatabase(message: String)
    case Prepare(message: String)
    case Step(message: String)
    case Bind(message: String)
}


class SQLiteDatabase
{
    
    var dataBasePointer: OpaquePointer?
    
    init()
    {
        dataBasePointer = openDatabaseConnection()
        createTable()
    }
    deinit
    {
        sqlite3_close(dataBasePointer)
    }
    
    func openDatabaseConnection() -> OpaquePointer?
    {
        var database: OpaquePointer?
        let databasePath: String = "LocalDatabase.sqlite"

         let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(databasePath)
        
        if sqlite3_open(fileURL.path, &database) == SQLITE_OK
        {
            print("Success! Database connection opened.")
            return database
        }
        else
        {
            do
            {
                if database != nil
                {
                    sqlite3_close(database)
                }
                
                return nil

            }
            /*
            if let errorPointer = sqlite3_errmsg(database) {
                let errorMessage = String(cString: errorPointer)
                throw SQLiteErrorMessages.OpenDatabase(message: errorMessage)
            }
            else
            {
                throw SQLiteErrorMessages.OpenDatabase(message: "No error message provided from Sqlite. Good luck!")
            }
             */
        }
    }
    
    
    fileprivate var errorMessage: String
    {
        if let errorPointer = sqlite3_errmsg(dataBasePointer)
        {
            let errorMessage = String(cString: errorPointer)
            return errorMessage
        }
        else{
            return "No error message provided from Sqlite. Good luck!"
        }
    }
    
    func prepareStatement(sqlString: String)throws -> OpaquePointer
    {
        var statement:OpaquePointer?
        guard sqlite3_prepare_v2(dataBasePointer, sqlString, -1, &statement, nil) == SQLITE_OK
            else{
                throw SQLiteErrorMessages.Prepare(message: errorMessage)
        }
        return statement!
    }
    
    func createTable()
    {
        
      
        let createTableString = "CREATE TABLE IF NOT EXISTS Murals (id INT PRIMARY KEY, xLocation INT, yLocation INT, name TEXT, artist TEXT, description TEXT, historicalContext TEXT, UNIQUE(id, xLocation, yLocation, name, artist, description, historicalContext))"

        do{ let createTableStatement:OpaquePointer? = try prepareStatement(sqlString: createTableString)
            
            defer{
                sqlite3_finalize(createTableStatement)

            }
            if(sqlite3_step(createTableStatement) == SQLITE_DONE)
            {
                print("Success! Table created!")
            }
            else{
                print("Failure! Could not create table.")
            }
            

        
        }
        catch{
            print("Failure! Could not create a table statement")
        }
        

       
    }
    
    
    func insertIntoTable(mural: Mural)
    {
        let createInsertString = "INSERT INTO Murals (id, xLocation, yLocation, name, artist, description, historicalContext) VALUES (?, ?, ?, ?, ?, ?, ?);"
        do{ let createInsertStatement:OpaquePointer? = try prepareStatement(sqlString: createInsertString)
            
                defer{
                    sqlite3_finalize(createInsertStatement)
                }
                 
                    guard
                    sqlite3_bind_int(createInsertStatement, 1, mural.id) == SQLITE_OK  &&
                    sqlite3_bind_int(createInsertStatement, 2, mural.xLocation) == SQLITE_OK &&
                    sqlite3_bind_int(createInsertStatement, 3, mural.yLocation) == SQLITE_OK &&
                    sqlite3_bind_text(createInsertStatement, 4, mural.name.utf8String, -1, nil) == SQLITE_OK &&
                    sqlite3_bind_text(createInsertStatement, 5, mural.artist.utf8String, -1, nil) == SQLITE_OK &&
                    sqlite3_bind_text(createInsertStatement, 6, mural.description.utf8String, -1, nil) == SQLITE_OK &&
                    sqlite3_bind_text(createInsertStatement, 7, mural.historicalContext.utf8String, -1, nil) == SQLITE_OK
                    else{
                        throw SQLiteErrorMessages.Bind(message: errorMessage)
                    }
                    if(sqlite3_step(createInsertStatement) == SQLITE_DONE)
                    {
                        print("Succesfully created insert statement")
                    }
                    else{
                        print("Failure! Could not create an insert statement.")
                    }
            /*
                    guard sqlite3_step(createInsertStatement) == SQLITE_DONE else {
                        throw SQLiteErrorMessages.Step(message: errorMessage)
                    }
                  */
                 
              
                    
             }
             catch{
                 print("Failure! Could not create an insert statement")
             }
    }
    
    /*
    func executeDatabaseOpen()
    {
        let database: SQLiteDatabase

        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(databasePath)
        
        do{
              database = try SQLiteDatabase.openDatabaseConnection(path: fileURL.path)
            print("Success! Connection opened to database.")

        }
        catch SQLiteErrorMessages.OpenDatabase(_) {
               print("Failure! Database connection not opened.")
        }
        catch{
            print("Failure! Unknown error.")
        }
        
    }
    */
    
    
}


