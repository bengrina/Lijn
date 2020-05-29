//
//  BookView.swift
//  Lijn
//
//  Created by Aymane on 19/05/2020.
//  Copyright © 2020 Aymane Bengrina. All rights reserved.
//

import SwiftUI

struct BookView: View {
    
    var thumbnail: String
    var title: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(thumbnail)
                .resizable()
                .frame(width: 192, height: 256)
            .shadow(radius: 4, x: 5, y: -5)
            .contextMenu {
                Button(action:{
                  print("Button 1")
                }){
                  HStack {
                      Image(systemName: "tag")
                      Text("Edit metadata")
                  }
                }
              Button(action:{
                print("Button 1")
              }){
                HStack {
                    Image(systemName: "trash")
                    Text("Delete")
                }
                
              }
              Button(action:{
                print("Button 2")
              }){
                HStack {
                    Image(systemName: "square.and.arrow.up")
                    Text("Share")
                }
              }
            }
                Text(title)
                    .font(.system(size: 16, weight: .light, design: .default))
                    .foregroundColor(Color(red: 0.38, green: 0.38, blue: 0.38, opacity: 1.0))
                .padding(.top, -9.0)
            
            }
        }
    }


struct BookView_Previews: PreviewProvider {
    static var previews: some View {
        BookView(thumbnail: "aama", title: "Aāma")
            .previewLayout(.fixed(width: 300, height: 300))
    }
}