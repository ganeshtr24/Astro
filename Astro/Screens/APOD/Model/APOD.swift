//
//  APOD.swift
//  Astro
//
//  Created by Ganesh TR on 20/03/23.
//

import Foundation

struct APOD: Codable {
    let copyright: String
    let date: String
    let explanation: String
    let url: String
    let hdurl: String
    let title: String
}
