//
//  CBZView.swift
//  Lijn
//
//  Created by Aymane on 15/07/2020.
//  Copyright © 2020 Aymane Bengrina. All rights reserved.
//

import SwiftUI
import ZIPFoundation

let cbzViewController = CBZViewController()

struct CBZView: View {
    let url: URL
    let pages: [Entry]
    
    init(_ url: URL) {
        self.url = url
        pages = cbzViewController.sortArchiveFromURL(url)!
    }
    
    
    var body: some View {
        ScrollView {
            ForEach(pages, id: \.path) { (page) in
                PageView(url: self.url, page: page)
            }
        }
//        Image(uiImage: cbzViewController.decodeImage(archive: url, entry: pages[0]))
    }
    
}

