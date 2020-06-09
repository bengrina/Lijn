//
//  DatabaseController.swift
//  Lijn
//
//  Created by Aymane on 21/05/2020.
//  Copyright © 2020 Aymane Bengrina. All rights reserved.
//

import Foundation
import RealmSwift

class BandeDessinee: Object, Identifiable {
    
    @objc dynamic var uuid = UUID().uuidString
    @objc dynamic var title = ""
    let creators = List<Creator>()
    @objc dynamic var thumbnailPath = "blankThumbnail"
    @objc dynamic var filePath = ""
    @objc dynamic var percentageRead = 0
    @objc dynamic var editor = ""
    @objc dynamic var serie = "none"
    @objc dynamic var serieNumber = 0
    @objc dynamic var publishedDate = Date(timeIntervalSince1970: 1)
    @objc dynamic var addedDate = Date(timeIntervalSinceNow: 0)
    
    override static func primaryKey() -> String? {
        return "uuid"
    }
    
}
class Creator: Object{
    @objc dynamic var name = ""
}


struct DatabaseController {
    
    func writeToDatabase(file: String,
                         title: String?,
                         creators: [String]?,
                         thumbnail: String?,
                         percentageRead: Int?,
                         editor: String?,
                         serie: String?,
                         serieNumber: Int?,
                         publishedDate: Date?
    ) {
        
        let bd = BandeDessinee()
        
        
        bd.filePath = file
        bd.uuid = UUID().uuidString
        
        if let tit = title {
            bd.title = tit
        }
        if let safeCreators = creators {
            for authors in safeCreators {
                let creator = Creator()
                creator.name = authors
                bd.creators.append(creator)
            }
            
        }
        if let thumb = thumbnail {
            bd.thumbnailPath = thumb
        }
        if let percentage = percentageRead {
            bd.percentageRead = percentage
        }
        if let edit = editor {
            bd.editor = edit
        }
        if let ser = serie {
            bd.serie = ser
        }
        if let serNum = serieNumber {
            bd.serieNumber = serNum
        }
        if let published = publishedDate {
            bd.publishedDate = published
        }
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(bd)
        }
        
        let contents = realm.objects(BandeDessinee.self)
        print(contents)
        
    }
    func resetDatabase() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
        
        let contents = realm.objects(BandeDessinee.self)
        print(contents)
    }
    func deleteDatabase() {
        try! FileManager.default.removeItem(at: Realm.Configuration.defaultConfiguration.fileURL!)
    }
    func updateDatabase() {
        let documentsFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileManager = FileManager.default
        
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsFolder, includingPropertiesForKeys: nil)
            writeToDatabase(file: fileURLs[0].absoluteString, title: nil, creators: nil, thumbnail: nil, percentageRead: nil, editor: nil, serie: nil, serieNumber: nil, publishedDate: nil)
        } catch {
            print("Error while enumerating files \(documentsFolder.path): \(error.localizedDescription)")
        }
    }
    func printDatabaseContents() {
        let realm = try! Realm()
        print(realm.objects(BandeDessinee.self))
        print(realm.objects(Creator.self))
    }
}





