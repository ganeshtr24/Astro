//
//  DefaultImageRepository.swift
//  Astro
//
//  Created by Ganesh TR on 26/03/23.
//

import Foundation
import UIKit

protocol ImageRepository {
    func fetchImage(with imageURL: String,
                    completion: @escaping (Result<Data, Error>) -> Void)
}

class DefaultImageRepository: ImageRepository {
    private let dataTransferService: DataTransferService
    private let cache: NSCacheDataStorage
    init(dataService: DataTransferService,
         cache: NSCacheDataStorage = NSCacheDataStorage()) {
        self.dataTransferService = dataService
        self.cache = cache
    }
    
    func fetchImage(with imageURL: String,
                    completion: @escaping (Result<Data, Error>) -> Void) {
        if let data = self.cache.fetch(for: imageURL) {
            completion(.success(data))
        } else {
            let endpoint = APIEndpoints.getImage(with: imageURL)
            dataTransferService.request(with: endpoint) { result in
                switch result {
                case .success(let data):
                        completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
