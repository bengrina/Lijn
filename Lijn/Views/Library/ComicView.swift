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
    @State var showOverlay = false
    var url: URL
    var body: some View {
        ZStack{
        PDFKitRepresentedView(url).onTapGesture {
            print("Tapped")
            self.showOverlay.toggle()
        }
            if showOverlay {
                ComicOverlay()
            }
        }
    }
}
struct PDFKitRepresentedView: UIViewRepresentable {
    let url: URL
    
    init(_ url: URL) {
        self.url = url
    }
    
    func makeUIView(context: UIViewRepresentableContext<PDFKitRepresentedView>) -> PDFKitRepresentedView.UIViewType {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: self.url)
        pdfView.autoScales = true
        return pdfView
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PDFKitRepresentedView>) {
        // Update the view.
    }
}

struct ComicView_Previews: PreviewProvider {
    static var previews: some View {
        ComicView(url: URL(fileURLWithPath: ""))
    }
}
