//
//  APODUseCase.swift
//  Astro
//
//  Created by Ganesh TR on 22/03/23.
//

import Foundation

struct APODRequest {
    let thumb: Bool
    let date: String
}

protocol APODUseCase {
    func execute(requestValue: APODRequest,
                 completion: @escaping (APOD?, Error?) -> Void)
}

final class DefaultAPODUseCase: APODUseCase {
    private let apodRepository : APODRepository
    
    init(apodRepository: APODRepository) {
        self.apodRepository = apodRepository
    }
    
    func execute(requestValue: APODRequest, completion: @escaping (APOD?, Error?) -> Void) {
        self.apodRepository.fetchAPOD(thumbs: requestValue.thumb,
                                      date: requestValue.date){ apod, error in
            completion(apod,error)
        }
    }
    
    
}
