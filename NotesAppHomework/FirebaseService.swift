//
//  FirebaseService.swift
//  NotesAppHomework
//
//  Created by Jakub Patelski on 15/02/2023.
//

import Foundation
import Firebase

class FirebaseService: ObservableObject {
    
    
    // Get a reference to the database
    let db = Firestore.firestore()
    @Published var list = [Item]()
    var notesCol = "notes2"
    
    
    func addData(title: String) {
           
           // Add a document to a collection
           db.collection(notesCol).addDocument(data: ["title": title,]) { error in
               
               // Check for errors
               if error == nil {
                   // No errors
                   
                   // Call get data to retrieve latest data
                   self.getData()
               }
               else {
                   // Handle the error
               }
           }
       }
       
       func getData() {

           // Read the documents at a specific path
           db.collection(notesCol).getDocuments { snapshot, error in
               
               // Check for errors
               if error == nil {
                   // No errors
                   
                   if let snapshot = snapshot {
                       
                       // Update the list property in the main thread
                       DispatchQueue.main.async {
                           
                           // Get all the documents and create Notes
                           self.list = snapshot.documents.map { d in
                               
                               // Create a Note(item i should change name if my struct that hold list) for each document returned
                               return Item(id: d.documentID,
                                           title: d["title"] as? String ?? "")
                                          
                           }
                       }
                       
                       
                   }
               }
               else {
                   // Handle the error
               }
           }
       }
 
    func deleteData(noteToDelete: Item) {
        
        // Specify the document to delete
        db.collection(notesCol).document(noteToDelete.id).delete { error in
            
            // Check for errors
            if error == nil {
                // No errors
                
                // Update the UI from the main thread
                DispatchQueue.main.async {
                    
                    // Remove the item that was just deleted
                    self.list.removeAll { note in
                        
                        // Check for the note to remove
                        return note.id == noteToDelete.id
                    }
                }
                
                
            }
        }
        
    }
    
}
