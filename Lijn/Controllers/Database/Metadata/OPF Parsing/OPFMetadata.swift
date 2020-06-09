//
//  OPFMetadata.swift
//  
//
//  Created by Aymane on 29/05/2020.
//

import Foundation

class Metadata: CustomStringConvertible {

    var uuid = ""
    var title = ""
    var creators = [""]
    var serie = ""
    var serieIndex = 0
    
    var description: String { return
        "UUID: \(uuid)\nTitre: \(title)\nAuteur(s): \(creators)\nSérie: Tome \(serieIndex) de la série \(serie)"
    }
    
}

class OPFParser: NSObject {
    var xmlParser: XMLParser?
    var metadata: [Metadata] = []
    var xmlText = ""
    var currentMetadata: Metadata?
    var calibreAttributes: [String: String] = [:]
    var isUUID = false
    
    init(withURL url: URL?) {
        if let data = url{
            xmlParser = XMLParser(contentsOf: data)
        }
    }
    
    func parse() -> [Metadata] {
        xmlParser?.delegate = self
        xmlParser?.parse()
        return metadata
    }
}

extension OPFParser: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        xmlText = ""
        if elementName == "metadata" {
            currentMetadata = Metadata()
        }
        if elementName == "meta" {
            //print("\(attributeDict["content"]) : \(attributeDict["name"])")
            if attributeDict["name"] == "calibre:series" {
                if let serie = attributeDict["content"] {
                    currentMetadata?.serie = serie
                    print(serie)
                }
            }
            if attributeDict["name"] == "calibre:series_index" {
                if let serieIndex = attributeDict["content"] {
                    currentMetadata?.serieIndex = Int(serieIndex) ?? 0
                }
            }
        }
        // Removed UUID parsing
//        if elementName == "dc:identifier" {
//            if let uuuid = attributeDict["opf:scheme"]{
//                if uuuid == "uuid" {
//                    isUUID = true
//                } else  {isUUID = false}
//
//            }
//        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
        case "dc:identifier":
            if isUUID == true {
                currentMetadata?.uuid = xmlText.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        case "dc:title":
            currentMetadata?.title = xmlText.trimmingCharacters(in: .whitespacesAndNewlines)
        case "dc:creator":
            currentMetadata?.creators.append(xmlText.trimmingCharacters(in: .whitespacesAndNewlines))
        case "metadata":
            if let meta = currentMetadata {
                metadata.append(meta)
            }
        default:
            break

    }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        xmlText += string
    }
}

class MetadataController {
func metadataDisplay() {
    do {
     if let xmlUrl = Bundle.main.url(forResource: "metadata", withExtension: "opf") {
        let opfParser = OPFParser(withURL: xmlUrl)
        let bandesDessinees = opfParser.parse()
        for bandeDessinee in bandesDessinees {
            bandeDessinee.creators = bandeDessinee.creators.filter({ $0 != ""})
            print(bandeDessinee)
        }
    } else {print("fichier non trouvé")}
    } catch {print(error)}
}
    
    func addMetadataToDatabase(ressource: String) {
         if let xmlUrl = Bundle.main.url(forResource: ressource, withExtension: "opf") {
            let opfParser = OPFParser(withURL: xmlUrl)
            let databaseController = DatabaseController()
            let bandeDessinee = opfParser.parse()
            bandeDessinee[0].creators = bandeDessinee[0].creators.filter({ $0 != ""})
            print("Adding\n\(bandeDessinee)\n to database ")
            databaseController.writeToDatabase(file: ressource, title: bandeDessinee[0].title, creators: bandeDessinee[0].creators, thumbnail: "cover.jpg", percentageRead: 0, editor: "unimplemented", serie: bandeDessinee[0].serie, serieNumber: bandeDessinee[0].serieIndex, publishedDate: nil)
            }
        }
    func addMetadataToDatabase(url: URL, fileUrl: String, thumbnailUrl: String) {
        let opfParser = OPFParser(withURL: url)
        let databaseController = DatabaseController()
        let bandeDessinee = opfParser.parse()
        bandeDessinee[0].creators = bandeDessinee[0].creators.filter({ $0 != ""})
        print("Adding\n\(bandeDessinee)\n to database ")
        databaseController.writeToDatabase(file: fileUrl, title: bandeDessinee[0].title, creators: bandeDessinee[0].creators, thumbnail: thumbnailUrl, percentageRead: 0, editor: "unimplemented", serie: bandeDessinee[0].serie, serieNumber: bandeDessinee[0].serieIndex, publishedDate: nil)
    }
}



