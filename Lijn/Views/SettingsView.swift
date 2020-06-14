//
//  SettingsView.swift
//  Lijn
//
//  Created by Aymane on 26/05/2020.
//  Copyright © 2020 Aymane Bengrina. All rights reserved.
//

import SwiftUI
let databaseController = DatabaseController()
let metadataController = MetadataController()



struct SettingsView: View {
    var body: some View {
        VStack {
            Button(action: {databaseController.updateDatabase()}) {
                Text("Update Database")
            }
            Button(action: {databaseController.resetDatabase()}) {
                Text("Reset database")
            }
            Button(action: {metadataController.metadataDisplay()}) {
                Text("Test parsing")
            }
            Button(action: {metadataController.addMetadataToDatabase(ressource: "metadata")
                metadataController.addMetadataToDatabase(ressource: "metadata1")
                
            }) {
                Text("Add metadata.opf to database")
            }
            Button(action: {databaseController.deleteDatabase()}) {
                Text("Delete database")
            }
            Button(action: {databaseController.printDatabaseContents()}) {
                Text("Print database contents")
            }
            Button(action: {documentsScanner.addBooksFromDocumentsToDatabase()}) {
                Text("add books from Documents folder")
            }
            Button(action: {documentsScanner.addBooksFromSubfoldersToDatabase()}) {
                Text("Add books from subfolders")
            }
            
            
        }
    }
}
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

