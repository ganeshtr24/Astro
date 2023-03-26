//
//  DefaultAPODRepository.swift
//  Astro
//
//  Created by Ganesh TR on 22/03/23.
//

import Foundation
class DefaultAPODRepository {
    private let dataTransferService: DataTransferService
    private let cache: APODResponseStorage
    private let lastFetchedAPOD = "last_fetched_apod"
    init(dataTransferService: DataTransferService, cache: APODResponseStorage) {
        self.dataTransferService = dataTransferService
        self.cache = cache
    }
}

extension DefaultAPODRepository:  APODRepository {
    func fetchAPOD(thumbs: Bool, date: String, cached: @escaping (APOD) -> Void, completion: @escaping (Result<APOD, Error>) -> Void) {
        let requestDTO = APODRequestDTO(thumbs: thumbs, date: date)
        self.cache.getResponse(for: requestDTO) { response in
            if let response {
                cached(response.toDomain())
            } else {
                let endpoint = APIEndpoints.getDPOD(with: requestDTO)
                
                self.dataTransferService.request(with: endpoint) { result in
                    switch result {
                    case.success(let responseDTO):
                        self.cache.save(response: responseDTO, for: requestDTO)
                        self.cache.save(response: responseDTO, for: APODRequestDTO(thumbs: false, date: self.lastFetchedAPOD))
                        completion(.success(responseDTO.toDomain()))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}
