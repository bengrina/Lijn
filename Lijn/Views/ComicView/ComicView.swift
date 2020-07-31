//
//  ComicView.swift
//  Lijn
//
//  Created by Aymane on 10/06/2020.
//  Copyright © 2020 Aymane Bengrina. All rights reserved.
//

import SwiftUI
import PDFKit

struct ComicView: View {
    @EnvironmentObject var userData: UserData
    @State var showOverlay = true
    @Environment(\.presentationMode) var presentationMode
    @State var hideStatusBar = false
    @State private var index: Int = 0
    var url: URL
    var body: some View {
        ZStack(alignment: .top){
            if url.pathExtension == "pdf"{
                PDFKitRepresentedView(url).onTapGesture {
                    self.showOverlay.toggle()
                    self.hideStatusBar.toggle()
                }
            }else{
                CBZView(url)

            }
            if showOverlay {
                ComicOverlay()
            }
            
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .statusBar(hidden: hideStatusBar)
    }
}


struct ComicView_Previews: PreviewProvider {
    static var previews: some View {
        ComicView(url: URL(fileURLWithPath: ""))
    }
}
