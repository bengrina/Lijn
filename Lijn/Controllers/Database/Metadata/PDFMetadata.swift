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
    func generateThumbnail(url: URL) -> UIImage?{
        guard let data = try? Data(contentsOf: url),
            let page = PDFDocument(data: data)?.page(at: 0) else {
                return nil
        }
        let pageSize = page.bounds(for: .mediaBox)
        let pdfScale = CGFloat(K.thumbWidth) / pageSize.width
        let scale = UIScreen.main.scale * pdfScale
        let screenSize = CGSize(width: pageSize.width * scale,
                                height: pageSize.height * scale)
        return page.thumbnail(of: screenSize, for: .cropBox)
    }
    func getMetadata(url: URL) -> [String:String?] {
        var title = ""
        var author: String?
        var attributes: [String:String?] = [:]
        do {
            guard let data = try? Data(contentsOf: url),
                let document = PDFDocument(data: data) else {
                    var titleFromUrl = url
                    titleFromUrl = titleFromUrl.deletingPathExtension()
                    title = titleFromUrl.lastPathComponent
                    attributes["title"] = title
                    return attributes
            }
            if let metadata = document.documentAttributes {
                if let titleExists = metadata[AnyHashable("Title")] {
                    if let titleIsEmpty = titleExists as? String {
                        title = titleIsEmpty
                        attributes["title"] = title
                    }
                } else {
                    var titleFromUrl = url
                    titleFromUrl = titleFromUrl.deletingPathExtension()
                    title = titleFromUrl.lastPathComponent
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
