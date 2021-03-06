//
//  APIManager.swift
//  Bad Character app
//
//  Created by Emil Vaklinov on 04/08/2020.
//  Copyright © 2020 Emil Vaklinov. All rights reserved.
//

import Foundation
import UIKit

enum Outcome {
    case success(Data)
    case failure(String)
}

struct APIManager {
    let imageCache: NSCache<NSString, UIImage>
    private let session: URLSession
    
    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
        imageCache = NSCache<NSString, UIImage>()
    }
    func searchFor(_ term: String, completion: @escaping (Outcome) -> Void) {

//        https://breakingbadapi.com/api/characters

        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "breakingbadapi.com"
        urlComponents.path = "/api/characters"

        guard let searchURL = urlComponents.url else {
            completion(.failure("Unable to make URL"))
            return
        }

        let dataTask = session.dataTask(with: searchURL) { (data, response, error) in

            if let error = error {
                completion(.failure(error.localizedDescription))
                print(error)
            } else if let data = data, let response = response as? HTTPURLResponse {

                switch response.statusCode {

                case 200...299:
                    completion(.success(data))
                    print(data)
                default:
                    completion(.failure("Response not in range 200-299"))

                }

            }

        }

        dataTask.resume()

    }
    
}
