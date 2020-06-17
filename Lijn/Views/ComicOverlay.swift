//
//  ComicOverlay.swift
//  Lijn
//
//  Created by Aymane on 14/06/2020.
//  Copyright © 2020 Aymane Bengrina. All rights reserved.
//

import SwiftUI

struct ComicOverlay: View {
    @EnvironmentObject var userData: UserData
    var body: some View {
        ZStack {
            Rectangle().size(width: UIScreen.main.bounds.size.width, height: 60).foregroundColor(Color(.systemFill))
            Button(action: {
                self.userData.showFullScreen.toggle()
            }) {
                Image(systemName: "arrow.left")
            }
            
        }.frame(width: UIScreen.main.bounds.size.width, height: 60, alignment: .top)
        
    }
}

struct ComicOverlay_Previews: PreviewProvider {
    static var previews: some View {
        ComicOverlay()
    }
}
