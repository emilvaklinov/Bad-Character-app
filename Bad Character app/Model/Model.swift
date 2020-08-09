//
//  Model.swift
//  Bad Character app
//
//  Created by Emil Vaklinov on 04/08/2020.
//  Copyright © 2020 Emil Vaklinov. All rights reserved.
//

import Foundation
import UIKit

struct CharacterRoot: Codable {
    var characters: [Character]
}
// MARK: - CharacterElement
struct Character: Codable {
    var char_id: Int64?
    var name: String?
    var occupation: [String]?
    var img: String?
    var status: String?
    var appearance: [Int64]?
}

