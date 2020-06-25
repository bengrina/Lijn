//
//  UserData.swift
//  Lijn
//
//  Created by Aymane on 07/06/2020.
//  Copyright © 2020 Aymane Bengrina. All rights reserved.
//

import Foundation
import SwiftUI

final class UserData: ObservableObject {
    @Published var showFullScreen = false
    @Published var filePath = URL(fileURLWithPath: "")
}
