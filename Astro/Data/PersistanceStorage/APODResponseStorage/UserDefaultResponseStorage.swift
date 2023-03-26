//
//  UserDefaultStorage.swift
//  Astro
//
//  Created by Ganesh TR on 22/03/23.
//

import Foundation

class UserDefaultResponseStorage: APODResponseStorage {
    
    let userDefault: UserDefaults
    
    init(userDefault: UserDefaults = UserDefaults.standard) {
        self.userDefault = userDefault
    }
    
    func getResponse(for request: APODRequestDTO, completion: @escaping (APODResponseDTO?) -> ()) {
        let responseDTO = userDefault.value(forKey: request.date) as? APODResponseDTO
        completion(responseDTO)
    }
    
    func save(response: APODResponseDTO, for requestDto: APODRequestDTO) {
        if let data = try? JSONEncoder().encode(response) {
            userDefault.set(data, forKey: requestDto.date)
        }
    }
}
