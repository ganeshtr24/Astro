//
//  APODViewModel.swift
//  Astro
//
//  Created by Ganesh TR on 21/03/23.
//

import Foundation


class APODViewModel {
    let service: DataTransferService
    
    init(service: DataTransferService) {
        self.service = service
    }
    
    func fetchAPOD() {
        let endPoint = APIEndpoints.getDPOD()
        
        self.service.request(with: endPoint) { result in
            
        }
    }
    
}
