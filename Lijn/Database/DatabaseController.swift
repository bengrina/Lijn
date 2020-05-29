//
//  DatabaseController.swift
//  Lijn
//
//  Created by Aymane on 21/05/2020.
//  Copyright © 2020 Aymane Bengrina. All rights reserved.
//

import Foundation
import RealmSwift

class BandeDessinee: Object {
    @objc dynamic var uuid = UUID().uuidString
    @objc dynamic var title = ""
    @objc dynamic var author = ""
    @objc dynamic var thumbnailPath = "blankThumbnail"
    @objc dynamic var filePath = ""
    @objc dynamic var percentageRead = 0
    @objc dynamic var editor = ""
    @objc dynamic var serie = "none"
    @objc dynamic var serieNumber = 0
    @objc dynamic var publishedDate = Date(timeIntervalSince1970: 1)
    @objc dynamic var addedDate = Date(timeIntervalSinceNow: 0)
}

struct DatabaseController {
    
    func writeToDatabase(file: String,
                         uuid: UUID,
                         title: String?,
                         author: String?,
                         thumbnail: String?,
                         percentageRead: Int?,
                         editor: String?,
                         serie: String?,
                         serieNumber: Int?,
                         publishedDate: Date?
    ) {
        
        let bd = BandeDessinee()
        
        bd.filePath = file
        bd.uuid = uuid.uuidString
        
        if let tit = title {
        bd.title = tit
        }
        if let auth = author {
            bd.author = auth
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
        try! realm.write {
            realm.deleteAll()
        }
        
        let contents = realm.objects(BandeDessinee.self)
        print(contents)
    }
    func updateDatabase() {
        let documentsFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileManager = FileManager.default
        
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsFolder, includingPropertiesForKeys: nil)
            writeToDatabase(file: fileURLs[0].absoluteString, uuid: UUID(), title: nil, author: nil, thumbnail: nil, percentageRead: nil, editor: nil, serie: nil, serieNumber: nil, publishedDate: nil)
        } catch {
            print("Error while enumerating files \(documentsFolder.path): \(error.localizedDescription)")
        }
    }
}





