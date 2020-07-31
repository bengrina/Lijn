//
//  CBZViewController.swift
//  
//
//  Created by Aymane on 30/07/2020.
//

import Foundation
import ZIPFoundation

struct CBZViewController {
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
    func sortArchiveFromURL(_ url: URL) -> [Entry]? {
        guard let archive = Archive(url: url, accessMode: .read) else  {
            print("no archive found")
            return nil
        }
        
        var sortedArchive = [Entry]()
        for item in archive {
            if item.path.hasSuffix("jpg") || item.path.hasSuffix("png"){
                sortedArchive.append(item)
            }
        }
        sortedArchive.sort()
        return sortedArchive
    }
    func decodeImage(archive url: URL, entry: Entry) -> UIImage {
        guard let archive = Archive(url: url, accessMode: .read) else  {
            print("no archive found")
            return UIImage(imageLiteralResourceName: K.blankCover)
        }
        print("URL AND ENTRY")
        print(url)
        print(entry.path)
        var singlePage = Data()
        do {

            
            let test = try archive.extract(entry, consumer: { (image) in
                singlePage.append(image)
            })
            print("DATA FROM ARCHIVE: \(singlePage.debugDescription)")
        }
        catch {
            print("Error in decodeImage(): \(error)")
        }
        let image = UIImage(data: singlePage)
        print("IMAGE: \(image.debugDescription)")
        if let safePage = image {
            print("SAFEPAGE: \(safePage.description)")
            return safePage
        } else {
            print("NO DECODED IMAGE")
            return UIImage(imageLiteralResourceName: K.blankCover)
        }
    }
}
