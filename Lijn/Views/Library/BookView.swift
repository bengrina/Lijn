//
//  BookView.swift
//  Lijn
//
//  Created by Aymane on 19/05/2020.
//  Copyright © 2020 Aymane Bengrina. All rights reserved.
//

import SwiftUI

struct BookView: View {
    @State var showingMetadataEditor = false
    @EnvironmentObject var userData: UserData
    
    var thumbnail: String?
    var title: String
    var filePath: String
    
    func thumbnail(_ thumbnail: String?) -> UIImage{
        if let cover = thumbnail {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let coverURL = documentsDirectory.appendingPathComponent(cover)
            do {
                let imageData = try Data(contentsOf: coverURL)
                return UIImage(data: imageData) ?? UIImage(imageLiteralResourceName: K.blankCover)
            } catch {
                print("Error loading image : \(error)")
                return UIImage(imageLiteralResourceName: K.blankCover)
            }
        } else {
            return UIImage(imageLiteralResourceName: K.blankCover)
        }
    }
    func filePath(_ filePath: String) -> URL {
        let url = documentsScanner.getDocumentsDirectory().appendingPathComponent(filePath)
        return url
    }
    
    func titleExists(_ title: String) -> String {
        if title.isEmpty {
            return K.blankTitle
        }
        else {
            return title}
    }
    
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(uiImage: thumbnail(thumbnail))
                .resizable()
                .frame(width: 192, height: 256)
                .shadow(radius: 4, x: 5, y: -5)
                .contextMenu {
                    Button(action:{
                        self.showingMetadataEditor.toggle()
                    }){
                        HStack {
                            Image(systemName: "tag")
                            Text("Edit metadata")
                        }
                    }
                    .sheet(isPresented: $showingMetadataEditor) {
                        MetadataEditor()
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
            Text(titleExists(title))
                .font(.system(size: 16, weight: .light, design: .default))
                .foregroundColor(Color(.label))
                .padding(.top, -9.0)
                .frame(width: 192, height: 18)
            
            
        }.buttonStyle(PlainButtonStyle())
            .onTapGesture {
                self.userData.filePath = self.filePath(self.filePath)
                self.userData.showFullScreen.toggle()
        }
        
    }
    
    struct BookView_Previews: PreviewProvider {
        static var previews: some View {
            BookView(thumbnail: "blankThumbnail", title: "Sample Book", filePath: "Sample Path")
                .previewLayout(.fixed(width: 300, height: 300))
        }
    }
}
