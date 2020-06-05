//
//  DocumentsScanner.swift
//  Lijn
//
//  Created by Aymane on 05/06/2020.
//  Copyright © 2020 Aymane Bengrina. All rights reserved.
//

import Foundation

extension FileManager {
    func urls(for directory: FileManager.SearchPathDirectory, skipsHiddenFiles: Bool = true ) -> [URL]? {
        let documentsURL = urls(for: directory, in: .userDomainMask)[0]
        let fileURLs = try? contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: skipsHiddenFiles ? .skipsHiddenFiles : [] )
        return fileURLs
    }
}

struct DocumentsScanner {
    func printDocumentsDirectoryContents() {
        let files = try! FileManager.default.urls(for: .documentDirectory, skipsHiddenFiles: true)
        let pdfFiles = files!.filter{ $0.pathExtension == "pdf" }
        print(pdfFiles)
        for pdfFile in pdfFiles {
            databaseController.writeToDatabase(file: String(pdfFile.absoluteString), uuid: "", title: String(pdfFile.lastPathComponent), creators: [""], thumbnail: "", percentageRead: 0, editor: "", serie: "", serieNumber: 0, publishedDate: nil)
        }
    }
    
    func fileIsInDatabase (filePath: String) -> Bool {
            return realm.object(ofType: BandeDessinee.self, forPrimaryKey: filePath) != nil
    }
}
