//
//  APODResponseStorage.swift
//  Astro
//
//  Created by Ganesh TR on 22/03/23.
//

import Foundation

protocol APODResponseStorage {
    func getResponse(for request: APODRequestDTO,
                     completion: @escaping (APODResponseDTO?)->())
    func save(response: APODResponseDTO, for requestDto: APODRequestDTO)
}
