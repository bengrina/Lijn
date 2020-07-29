//
//  CBZMetadata.swift
//  Lijn
//
//  Created by Aymane on 09/06/2020.
//  Copyright © 2020 Aymane Bengrina. All rights reserved.
//

import Foundation
import ZIPFoundation

let imageResizer = ImageResizer()

extension Entry: Comparable {
    public static func < (lhs: Entry, rhs: Entry) -> Bool {
        if lhs.path != rhs.path {
            return lhs.path < rhs.path
        } else {
            return lhs.path == rhs.path
        }
    }
}

struct CBZMetadata {
    func generateThumbnail(url: URL){
        // TODO: Resize thumbnails, they can be way too big
        guard let archive = Archive(url: url, accessMode: .read) else  {
            return
        }
        
        var sortedArchive = [Entry]()
        for item in archive {
            if item.path.hasSuffix("jpg") || item.path.hasSuffix("png"){
                sortedArchive.append(item)
            }
        }
        sortedArchive.sort()
        
        let workingURL = url.deletingLastPathComponent()
        var coverType = ""
        var coverURL: URL = URL(fileURLWithPath: "")
        if sortedArchive[0].path.hasSuffix("jpg") || sortedArchive[0].path.hasSuffix("jpeg") {
            coverURL = workingURL.appendingPathComponent("tempCover.jpg")
            coverType = "jpg"
        } else if sortedArchive[0].path.hasSuffix("png") {
            coverURL = workingURL.appendingPathComponent("tempCover.png")
            coverType = "png"
        }
        do {
            let testURL = workingURL.appendingPathComponent("cover.png")
            try archive.extract(sortedArchive[0], to: coverURL)
            let dimensions = CGSize(width: CGFloat(integerLiteral: K.thumbHeight), height: CGFloat(integerLiteral: K.thumbWidth))
            try? imageResizer.resizedImage(at: coverURL, for: dimensions)?.pngData()!.write(to: testURL)
            let fileManager = FileManager.default
            try? fileManager.removeItem(at: coverURL)
        }
        catch {
            print(error)
        }
    }
    func getMetadata(url: URL) {
        
    }
    func sortArchive(archive: Archive){
        
    }
}
