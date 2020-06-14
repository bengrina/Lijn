//
//  ContentView.swift
//  Lijn
//
//  Created by Aymane on 20/05/2020.
//  Copyright © 2020 Aymane Bengrina. All rights reserved.
//

import SwiftUI


struct ContentView: View {
    @State private var selection = 0
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        ZStack{
            TabView(selection: $selection){
                LibraryView()
                    .font(.title)
                    .tabItem {
                        VStack {
                            Image(systemName: "book")
                            Text("Library")
                        }
                        
                }
                .tag(0)
                ImportView()
                    .font(.title)
                    .tabItem {
                        VStack {
                            Image(systemName: "folder")
                            Text("Import Comic")
                        }
                }
                .tag(1)
                Text("Get new books")
                    .font(.title)
                    .tabItem {
                        VStack {
                            Image(systemName: "globe")
                            Text("Browse Comics")
                        }
                }
                .tag(2)
                SettingsView()
                    .font(.title)
                    .tabItem {
                        VStack {
                            Image(systemName: "gear")
                            Text("Settings")
                        }
                }
                .tag(3)
            }
            if userData.showFullScreen {
                
                ComicView(url: userData.filePath)
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice(.init(rawValue: "iPad (7th generation)"))
    }
}
