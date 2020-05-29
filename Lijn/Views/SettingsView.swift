//
//  SettingsView.swift
//  Lijn
//
//  Created by Aymane on 26/05/2020.
//  Copyright © 2020 Aymane Bengrina. All rights reserved.
//

import SwiftUI


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

        }
            }
        }
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
 
