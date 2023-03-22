//
//  APODViewModel.swift
//  Astro
//
//  Created by Ganesh TR on 21/03/23.
//

import Foundation


class APODViewModel {
    let service: DataTransferService
    var aPod: APOD?
    
    init(service: DataTransferService) {
        self.service = service
    }
    
    func fetchAPOD(completion: @escaping (APOD)->Void) {
        let endPoint = APIEndpoints.getDPOD()
        self.service.request(with: endPoint) {[weak self] result in
            guard let self else { return }
            switch result {
            case .success(let apod):
                self.aPod = apod
                completion(apod)
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
