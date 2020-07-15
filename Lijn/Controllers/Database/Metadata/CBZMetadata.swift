//
//  CBZMetadata.swift
//  Lijn
//
//  Created by Aymane on 09/06/2020.
//  Copyright © 2020 Aymane Bengrina. All rights reserved.
//

import Foundation
import ZIPFoundation

struct CBZMetadata {
    func generateThumbnail(url: URL) {
        guard let archive = Archive(url: url, accessMode: .read) else  {
            return
        }
        print("ARCHIVE")
        for item in archive {
            print(item.path)
        }
    }
    func getMetadata(url: URL) {
        
    }
}
