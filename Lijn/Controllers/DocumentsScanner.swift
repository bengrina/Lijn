//
//  DocumentsScanner.swift
//  Lijn
//
//  Created by Aymane on 05/06/2020.
//  Copyright © 2020 Aymane Bengrina. All rights reserved.
//

import Foundation
let pdfMetadata = PDFMetadata()

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
        // At this point in time: Putting in a folder works, but no cover is generated
        let files = try! FileManager.default.urls(for: .documentDirectory, skipsHiddenFiles: true)
        let pdfFiles = files!.filter{ $0.pathExtension == "pdf" }
        print(pdfFiles)
        for pdfFile in pdfFiles {
            // filePath property: Create a folder, put PDF in it, put that to the database (Don't create before the if)
            let pdfPath = pdfFile.path
            print("-----PDFFILE AND PDFPATH---")
            print(pdfFile)
            print(pdfPath)
            
            let pdfFolder = pdfFile.deletingPathExtension()
            let potentialPath = pdfFolder.lastPathComponent + "/" + pdfFile.lastPathComponent
            print("POTENTIAL PATH \(potentialPath)")
            if fileIsInDatabase(filePath: potentialPath) {
                // Create directory https://stackoverflow.com/a/26931481/13642472
                // And move the pdf file there

                let directoryPath = getDocumentsDirectory().appendingPathComponent(pdfFolder.lastPathComponent)
                print("DIRECTORY PATH: \(directoryPath)")
                let folderPath = directoryPath.appendingPathComponent(pdfFile.lastPathComponent)
                print("FOLDER PATH: \(folderPath)")
                if !FileManager.default.fileExists(atPath: directoryPath.absoluteString) {
                    do {
                        try FileManager.default.createDirectory(at: directoryPath, withIntermediateDirectories: true, attributes: nil)
                        try FileManager.default.moveItem(at: pdfFile, to: directoryPath.appendingPathComponent(pdfFile.lastPathComponent))
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                if let thumbnail = pdfMetadata.generateThumbnail(url: folderPath) {
                    if let data = thumbnail.jpegData(compressionQuality: 0.8) {
                        let filename = directoryPath.appendingPathComponent(K.coverFromCalibre)
                        try? data.write(to: filename)
                    }
                }
                let thumbnailPath = pdfFolder.lastPathComponent + "/" + K.coverFromCalibre
                
                databaseController.writeToDatabase(file: potentialPath, uuid: "", title: String(pdfFile.lastPathComponent), creators: [""], thumbnail: thumbnailPath, percentageRead: 0, editor: "", serie: "", serieNumber: 0, publishedDate: nil)
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
            
            // Prendre le nom du dossier y ajouter les documents PUIS enregistrer cette URL
            let dirName = subDir.lastPathComponent
            let fileUrls = try! fileManager.contentsOfDirectory(at: subDir, includingPropertiesForKeys: nil)
            let bdFiles = fileUrls.filter { $0.pathExtension == "pdf" || $0.pathExtension == "cbz"}
            
            for bdFile in bdFiles {
                let bdFileName = bdFile.lastPathComponent
                let path = dirName + "/" + bdFileName
                if fileIsInDatabase(filePath: path) {
                    let metadataToParse = subDir.appendingPathComponent(K.metadataFromCalibre)
                    let coverPath = dirName + "/" + K.coverFromCalibre
                    if fileManager.fileExists(atPath: metadataToParse.path) {
                        // If a metadata.opf file is present in the folder
                        print("Success for \(bdFile)")
                        metadataController.addMetadataToDatabase(url: metadataToParse, fileUrl: path, thumbnailUrl: coverPath)
                    } else {
                        // If there's no metadata.opf
                        print("No metadata file found at \(subDir.appendingPathComponent(K.metadataFromCalibre))")
                        databaseController.writeToDatabase(file: path, uuid: "", title: bdFileName, creators: [""], thumbnail: "", percentageRead: 0, editor: "unimplemented", serie: "", serieNumber: 0, publishedDate: nil)
                    }
                }
            }
        }
        
        
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}
