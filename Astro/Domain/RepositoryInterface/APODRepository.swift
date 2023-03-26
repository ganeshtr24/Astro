//
//  APODRepository.swift
//  Astro
//
//  Created by Ganesh TR on 22/03/23.
//

import Foundation

protocol APODRepository {
    func fetchAPOD(thumbs: Bool,
                   date: String,
                   completion: @escaping (APOD?, Error?) -> Void)
}
