//
//  ContentView.swift
//  Lijn
//
//  Created by Aymane on 18/05/2020.
//  Copyright © 2020 Aymane Bengrina. All rights reserved.
//

import SwiftUI
import RealmSwift
import WaterfallGrid

let documentsScanner = DocumentsScanner()

class BindableResults<Element>: ObservableObject where Element: RealmSwift.RealmCollectionValue {
    var results: Results<Element>
    private var token: NotificationToken!
    init(results: Results<Element>) {
        self.results = results
        lateInit()
    }
    func lateInit() {
        let realm = try! Realm()
        let bds = realm.objects(BandeDessinee.self)
        token = bds.observe { [weak self] _ in
            self!.results = self!.results
        }
    }
    deinit {
        token.invalidate()
    }
}

struct LibraryView: View {
    @ObservedObject var bds = BindableResults<BandeDessinee>(results: try! Realm().objects(BandeDessinee.self))
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "New York Extra Large", size: 36)!]
        UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "New York Extra Large", size: 20)!]
        UITableView.appearance().separatorColor = .clear
    }
 
    var body: some View {
        NavigationView {
            Section {
                WaterfallGrid(bds.results.sorted(byKeyPath: "title", ascending: true), id: \.uuid) { bd in
                    BookView(thumbnail: bd.thumbnailPath, title: bd.title, filePath: bd.filePath)
                    
                }
            }
            .gridStyle(
                columnsInPortrait: 3,
                columnsInLandscape: 4
            )
                .navigationBarTitle("Library")
                .padding(EdgeInsets(top: 0, leading: 48, bottom: 0, trailing: 48))
            
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}


struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
            .previewDevice(.init(rawValue: "iPad (7th generation)"))
    }
}

