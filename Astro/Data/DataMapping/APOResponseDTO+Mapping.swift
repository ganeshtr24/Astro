//
//  APOResponseDTO+Mapping.swift
//  Astro
//
//  Created by Ganesh TR on 22/03/23.
//

import Foundation

struct APODResponseDTO: Codable {
    let copyright: String?
    let date: String?
    let explanation: String?
    let url: String?
    let hdurl: String?
    let title: String?
    let thumbnail_url: String?
}

extension APODResponseDTO {
    func toDomain() -> APOD {
        .init(copyright: self.copyright, date: self.date,
              explanation: self.explanation, url: self.url,
              hdurl: self.hdurl, title: self.title, thumbnailURL: thumbnail_url)
    }
}
