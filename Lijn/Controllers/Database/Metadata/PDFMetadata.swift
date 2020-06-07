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
    func generateThumbnail(url: URL) -> UIImage?{
        guard let data = try? Data(contentsOf: url),
        let page = PDFDocument(data: data)?.page(at: 0) else {
          return nil
        }
        let pageSize = page.bounds(for: .mediaBox)
        let pdfScale = CGFloat(K.thumbWidth) / pageSize.width

        // Apply if you're displaying the thumbnail on screen
        let scale = UIScreen.main.scale * pdfScale
        let screenSize = CGSize(width: pageSize.width * scale,
                                height: pageSize.height * scale)

        return page.thumbnail(of: screenSize, for: .mediaBox)
        
    }
}
