//
//  K.swift
//  Lijn
//
//  Created by Aymane on 07/06/2020.
//  Copyright © 2020 Aymane Bengrina. All rights reserved.
//

import Foundation
import RealmSwift

struct K {
    static let thumbHeight = 1024
    static let thumbWidth = 768
    static let metadataFromCalibre = "metadata.opf"
    static let calibreCover = "cover.jpg"
    static let generatedCover = "cover.png"
    static let blankCover = "blankThumbnail"
    static let blankTitle = "No Title"
    static let documentsDirectoryURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    static let libraryDirectoryURL = try! FileManager.default.url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
}
