//
//  APIEndpoints.swift
//  Astro
//
//  Created by Ganesh TR on 21/03/23.
//

import Foundation

struct APIEndpoints {
    static func getDPOD(with apodRequestDTO: APODRequestDTO) -> Endpoint<APODResponseDTO> {
        return Endpoint(path: "planetary/apod",
                        method: .get,
                        queryParameters: ["thumbs": apodRequestDTO.thumbs])
    }
    
    static func getImage(with url: String) -> Endpoint<Data> {
        return Endpoint(path: url,isFullPath: true, method: .get, responseDecoder: RawDataResponseDecoder())
    }
    
}
