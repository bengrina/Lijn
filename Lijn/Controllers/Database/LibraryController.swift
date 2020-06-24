////
////  LibraryController.swift
////  Lijn
////
////  Created by Aymane on 31/05/2020.
////  Copyright © 2020 Aymane Bengrina. All rights reserved.
////
//
//import Foundation
//import RealmSwift
//
//struct LibraryController {
//    class BindableResults<Element>: ObservableObject where Element: RealmSwift.RealmCollectionValue {
//
//        var results: Results<Element>
//        private var token: NotificationToken!
//
//        init(results: Results<Element>) {
//            self.results = results
//            lateInit()
//        }
//
//        func lateInit() {
//            let realm = try! Realm()
//            let bds = realm.objects(BandeDessinee.self)
//            token = bds.observe { [weak self] _ in
//                self!.results = self!.results
//            }
//        }
//
//        deinit {
//            token.invalidate()
//        }
//    }
//}
