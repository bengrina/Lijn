//
//  PDFMetadata.swift
//  Lijn
//
//  Created by Aymane on 05/06/2020.
//  Copyright © 2020 Aymane Bengrina. All rights reserved.
//

import Foundation
import PDFKit

struct PDFMetadata {
    // https://stackoverflow.com/a/48929065/13642472
    // generateThumbnail(url: URL) -> UIImage?: Generates a thumbnail from a PDF file.
    func generateThumbnail(url: URL) -> Bool{
        guard let data = try? Data(contentsOf: url),
            let page = PDFDocument(data: data)?.page(at: 0) else {
                return false
        }
        let pageSize = page.bounds(for: .mediaBox)
        let pdfScale = CGFloat(K.thumbWidth) / pageSize.width
        let scale = UIScreen.main.scale * pdfScale
        let screenSize = CGSize(width: pageSize.width * scale,
                                height: pageSize.height * scale)
        if let thumbnail = page.thumbnail(of: screenSize, for: .cropBox).pngData() {
        let thumbURL = url.deletingLastPathComponent().appendingPathComponent("cover.png")
        try? thumbnail.write(to: thumbURL)
        }
        return true
    }
    //MARK: - getMetadata: Gets metadata from a PDF document and returns an array of metadata.
    func getMetadata(url: URL) -> [String:String?] {
        var title = ""
        var author: String?
        var attributes: [String:String?] = [:]
        do {
            guard let data = try? Data(contentsOf: url),
                let document = PDFDocument(data: data) else {
                    var titleFromUrl = url
                    titleFromUrl = titleFromUrl.deletingPathExtension()
                    title = titleFromUrl.lastPathComponent.replacingOccurrences(of: "_", with: " ")
                    attributes["title"] = title
                    return attributes
            }
            if let metadata = document.documentAttributes {
                if let titleExists = metadata[AnyHashable("Title")] {
                    if let titleIsEmpty = titleExists as? String {
                        title = titleIsEmpty.replacingOccurrences(of: "_", with: " ")
                        attributes["title"] = title
                    }
                } else {
                    var titleFromUrl = url
                    titleFromUrl = titleFromUrl.deletingPathExtension()
                    title = titleFromUrl.lastPathComponent.replacingOccurrences(of: "_", with: " ")
                    attributes["title"] = title
                }
                if let authorExists = metadata[AnyHashable("Author")] {
                    if let authorIsEmpty = authorExists as? String {
                        author = authorIsEmpty
                        attributes["author"] = author
                    } else {
                        attributes["author"] = nil
                    }
                }
            }
        }
        return attributes
    }
}
