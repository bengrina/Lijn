//
//  PageView.swift
//  Lijn
//
//  Created by Aymane on 30/07/2020.
//  Copyright © 2020 Aymane Bengrina. All rights reserved.
//

import SwiftUI
import ZIPFoundation

struct PageView: View {
    let url: URL
    let page: Entry
    
    var body: some View {
        Image(uiImage: cbzViewController.decodeImage(archive: url, entry: page))
            .resizable()
            .clipped()
    }
}
