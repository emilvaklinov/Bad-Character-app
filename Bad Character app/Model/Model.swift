//
//  Model.swift
//  Bad Character app
//
//  Created by Emil Vaklinov on 04/08/2020.
//  Copyright © 2020 Emil Vaklinov. All rights reserved.
//

import Foundation

import UIKit

// MARK: - CharacterElement
struct Character: Decodable {
    let char_id: Int?
    let name: String?
    let occupation: [String]?
    let img: String?
    let status: String?
    let appearance: [Int]?
}
