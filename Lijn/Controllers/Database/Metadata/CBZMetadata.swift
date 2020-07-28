//
//  CBZMetadata.swift
//  Lijn
//
//  Created by Aymane on 09/06/2020.
//  Copyright © 2020 Aymane Bengrina. All rights reserved.
//

import Foundation
import ZIPFoundation

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
    func generateThumbnail(url: URL) -> String {
        // TODO: Resize thumbnails, they can be way too big
        guard let archive = Archive(url: url, accessMode: .read) else  {
            return ""
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
            coverURL = workingURL.appendingPathComponent(K.coverFromCalibre)
            coverType = "jpg"
        } else if sortedArchive[0].path.hasSuffix("png") {
            coverURL = workingURL.appendingPathComponent("cover.png")
            coverType = "png"
        }
        do {
            try archive.extract(sortedArchive[0], to: coverURL)
        }
        catch {
            print(error)
        }
        
        return coverType
    }
    func getMetadata(url: URL) {
        
    }
    func sortArchive(archive: Archive){
        
    }
}
