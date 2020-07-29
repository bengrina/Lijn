//
//  DocumentsScanner.swift
//  Lijn
//
//  Created by Aymane on 05/06/2020.
//  Copyright © 2020 Aymane Bengrina. All rights reserved.
//

import Foundation
import RealmSwift
let pdfMetadata = PDFMetadata()
let cbzMetadata = CBZMetadata()

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
    func moveSingleFilesInsideFolders() {
        let files = FileManager.default.urls(for: .documentDirectory, skipsHiddenFiles: true)
        let comics = files!.filter{ $0.pathExtension == "pdf" || $0.pathExtension == "cbz"}
        DispatchQueue.global(qos: .default).async {
            for comic in comics {
                let pdfFolder = comic.deletingPathExtension()
                let potentialPath = pdfFolder.lastPathComponent + "/" + comic.lastPathComponent
                let escapePotentialPath = potentialPath.replacingOccurrences(of: "\'", with: #"\'"#)
                if self.fileIsInDatabase(filePath: escapePotentialPath) {
                    // Create directory https://stackoverflow.com/a/26931481/13642472
                    // And move the file there
                    let directoryPath = self.getDocumentsDirectory().appendingPathComponent(pdfFolder.lastPathComponent)
                    if !FileManager.default.fileExists(atPath: directoryPath.absoluteString) {
                        do {
                            try FileManager.default.createDirectory(at: directoryPath, withIntermediateDirectories: true, attributes: nil)
                            try FileManager.default.moveItem(at: comic, to: directoryPath.appendingPathComponent(comic.lastPathComponent))
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
    
    func fileIsInDatabase (filePath: String) -> Bool {
        let realm = try! Realm()
        let bd = realm.objects(BandeDessinee.self).filter("filePath = '\(filePath)'")
        if bd.isEmpty {
            return true
        } else {
            return false
        }
    }
    func addComicsToDatabase() {
        moveSingleFilesInsideFolders()
        let fileManager = FileManager.default
        let subDirs = K.documentsDirectoryURL.subDirectories
        let squeue = DispatchQueue(label: "squeue.subfolders.gcd")
        
        squeue.async {
            for subDir in subDirs { // Iterate through the found subfolders in 
                
                // Prendre le nom du dossier y ajouter les documents PUIS enregistrer cette URL
                let dirName = subDir.lastPathComponent
                let fileUrls = try! fileManager.contentsOfDirectory(at: subDir, includingPropertiesForKeys: nil)
                let bdFiles = fileUrls.filter { $0.pathExtension == "pdf" || $0.pathExtension == "cbz"}
                
                for bdFile in bdFiles {
                    let bdFileName = bdFile.lastPathComponent
                    let path = dirName + "/" + bdFileName
                    
                    let escapePath = path.replacingOccurrences(of: "\'", with: #"\'"#)
                    
                    var thumbnailPath = ""
                    if self.fileIsInDatabase(filePath: escapePath) {
                        let metadataToParse = subDir.appendingPathComponent(K.metadataFromCalibre)
                        let coverPath = dirName + "/" + K.coverFromCalibre
                        if fileManager.fileExists(atPath: metadataToParse.path) {
                            // If a metadata.opf file is present in the folder
                            metadataController.addMetadataToDatabase(url: metadataToParse, fileUrl: path, thumbnailUrl: coverPath)
                        } else {
                            // If there's no metadata.opf
                            let metadata = pdfMetadata.getMetadata(url: bdFile)
                            var comicTitle = ""
                            var comicAuthors: [String]?
                            print("No metadata file found at \(subDir.appendingPathComponent(K.metadataFromCalibre))")
                            if bdFile.pathExtension == "pdf" {
                                if pdfMetadata.generateThumbnail(url: bdFile){
                                    thumbnailPath = dirName + "/" + K.coverFromCalibre
                                    print(thumbnailPath)
                                } else {
                                    thumbnailPath = ""
                                }
                                
                                if let title = metadata["title"]{
                                    comicTitle = title!
                                }
                                if let author = metadata["author"]{
                                    if let comicAuthor = author{
                                        comicAuthors?.append(comicAuthor)
                                    }
                                }
                            }else {
                                if bdFile.pathExtension == "cbz" {
                                    
                                    switch cbzMetadata.generateThumbnail(url: bdFile) {
                                    case "jpg":
                                        thumbnailPath = dirName + "/" + K.coverFromCalibre
                                    case "png":
                                        thumbnailPath = dirName + "/" + "cover.png"
                                    default :
                                        thumbnailPath = ""
                                    }
                                    comicTitle = bdFile.lastPathComponent
                                }
                            }
                            databaseController.writeToDatabase(file: escapePath, title: comicTitle, creators: comicAuthors, thumbnail: thumbnailPath, percentageRead: 0, editor: "unimplemented", serie: "", serieNumber: 0, publishedDate: nil)
                        }
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
