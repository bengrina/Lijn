//
//  ContentView.swift
//  Lijn
//
//  Created by Aymane on 18/05/2020.
//  Copyright © 2020 Aymane Bengrina. All rights reserved.
//

import SwiftUI
import RealmSwift

let metadataController = TestMetadata()
struct LibraryView: View {
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "New York Extra Large", size: 44)!]
        UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "New York Extra Large", size: 20)!]
        UITableView.appearance().separatorColor = .clear
    }
    
    var body: some View {
        NavigationView {
            List {
                HStack(spacing: 48) {
                    BookView(thumbnail: "aama", title: "Aāma")

                    BookView(thumbnail: "survivants", title: "Survivants")

                    BookView(thumbnail: "archanges", title: "Les Archanges de Vinéa")

                    
                }
                HStack(spacing: 48) {
                    BookView(thumbnail: "centaurus", title: "Centaurus")

                    BookView(thumbnail: "promethee", title: "Prométhée")

                    BookView(thumbnail: "dexter", title: "Dexter London")

                }
                    
            }
            .navigationBarTitle("Library")
            .padding(EdgeInsets(top: 0, leading: 48, bottom: 0, trailing: 48))

        }
        .navigationViewStyle(StackNavigationViewStyle())

        

    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
        .previewDevice(.init(rawValue: "iPad (7th generation)"))
    }
}
