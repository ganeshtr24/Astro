//
//  APIEndpoints.swift
//  Astro
//
//  Created by Ganesh TR on 21/03/23.
//

import Foundation

struct APIEndpoints {
    static func getDPOD() -> Endpoint<APOD> {
        return Endpoint(path: "planetary/apod",
                        method: .get,
                        queryParameters: ["thumbs": true])
    }
}
