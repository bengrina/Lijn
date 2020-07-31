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
        guard let archive = Archive(url: url, accessMode: .read) else  {
            return
        }
        let sortedArchive = sortArchive(archive)
        let workingURL = url.deletingLastPathComponent()
        var coverURL: URL = URL(fileURLWithPath: "")
        if sortedArchive[0].path.hasSuffix("jpg") || sortedArchive[0].path.hasSuffix("jpeg") {
            coverURL = workingURL.appendingPathComponent("tempCover.jpg")
        } else if sortedArchive[0].path.hasSuffix("png") {
            coverURL = workingURL.appendingPathComponent("tempCover.png")
        }
        do {
            let testURL = workingURL.appendingPathComponent(K.generatedCover)
            try _ = archive.extract(sortedArchive[0], to: coverURL)
            let dimensions = CGSize(width: CGFloat(integerLiteral: K.thumbHeight), height: CGFloat(integerLiteral: K.thumbWidth))
            try imageResizer.resizedImage(at: coverURL, for: dimensions)?.pngData()!.write(to: testURL)
            let fileManager = FileManager.default
            try fileManager.removeItem(at: coverURL)
        }
        catch {
            print(error)
        }
    }
    func getMetadata(url: URL) {
        
    }
    func sortArchive(_ archive: Archive) -> [Entry] {
        var sortedArchive = [Entry]()
        for item in archive {
            if item.path.hasSuffix("jpg") || item.path.hasSuffix("png"){
                sortedArchive.append(item)
            }
        }
        sortedArchive.sort()
        return sortedArchive
    }
}
