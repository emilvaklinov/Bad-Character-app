//
//  Parser.swift
//  Bad Character app
//
//  Created by Emil Vaklinov on 04/08/2020.
//  Copyright © 2020 Emil Vaklinov. All rights reserved.
//

import Foundation

// Unified parser to parse the data from JSON with T Type. returning T where T is decodable and returning decoded data.

struct JSONParser {

    static func parse<T>(_ data: Data, type: T.Type) throws -> T where T : Decodable {

        return try JSONDecoder().decode(type.self, from: data)

    }

}
