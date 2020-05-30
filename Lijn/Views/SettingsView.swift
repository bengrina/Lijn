//
//  SettingsView.swift
//  Lijn
//
//  Created by Aymane on 26/05/2020.
//  Copyright © 2020 Aymane Bengrina. All rights reserved.
//

import SwiftUI
let databaseController = DatabaseController()

struct SettingsView: View {
    @State var title: String = ""
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
            Button(action: {metadataController.addMetadataToDatabase()}) {
                        Text("Add metadata.opf to database")
            }
            Button(action: {databaseController.resetDatabase()}) {
                        Text("Delete database")
            }
            Button(action: {databaseController.printDatabaseContents()}) {
                        Text("Print database contents")
            }

        }
            }
        }
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
 
