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

extension URL {
    var isDirectory: Bool {
        return (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true
    }
    var subDirectories: [URL] {
        guard isDirectory else { return [] }
        return (try? FileManager.default.contentsOfDirectory(at: self, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles]).filter(\.isDirectory)) ?? []
    }
}

struct DocumentsScanner {
    func printDocumentsDirectoryContents() {
        let files = try! FileManager.default.urls(for: .documentDirectory, skipsHiddenFiles: true)
        let pdfFiles = files!.filter{ $0.pathExtension == "pdf" }
        print(pdfFiles)
        for pdfFile in pdfFiles {
            if fileIsInDatabase(filePath: pdfFile.absoluteString) {
            databaseController.writeToDatabase(file: String(pdfFile.absoluteString), uuid: "", title: String(pdfFile.lastPathComponent), creators: [""], thumbnail: "", percentageRead: 0, editor: "", serie: "", serieNumber: 0, publishedDate: nil)
            }
        }
    }
    
    func fileIsInDatabase (filePath: String) -> Bool {
            return realm.object(ofType: BandeDessinee.self, forPrimaryKey: filePath) == nil
    }
    func printSubdirectories() {
        let fileManager = FileManager.default
        let documentsDirectoryURL =  try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let subDirs = documentsDirectoryURL.subDirectories
        
        for subDir in subDirs {
            let fileUrls = try! fileManager.contentsOfDirectory(at: subDir, includingPropertiesForKeys: nil)
            let bdFiles = fileUrls.filter { $0.pathExtension == "pdf" || $0.pathExtension == "cbz"}
            
            for bdFile in bdFiles {
                if fileIsInDatabase(filePath: bdFile.absoluteString) {
                let pathComponent = subDir.appendingPathComponent("metadata.opf")
                let metadataPath = pathComponent.path
                let coverComponent = subDir.appendingPathComponent("cover.jpg")
                let coverPath = coverComponent.path
                    
                if fileManager.fileExists(atPath: metadataPath) {
                    print("Success for \(bdFile)")
                    metadataController.addMetadataToDatabase(url: pathComponent, fileUrl: bdFile.absoluteString, thumbnailUrl: coverPath)
                    } else {print("No metadata file found at \(subDir.appendingPathComponent("metadata.opf"))")}
                }
            }
        }
        
        
    }
}
