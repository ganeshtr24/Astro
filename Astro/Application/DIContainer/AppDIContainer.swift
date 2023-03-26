//
//  AppDIContainer.swift
//  Astro
//
//  Created by Ganesh TR on 22/03/23.
//

import Foundation
class AppDIContainer {
    
    lazy var appConfiguration = AppConfiguration()
    
//     MARK: - Network
    lazy var apiDataTransferService: DataTransferService = {
        let config = DefaultNetworkConfig(baseURL: URL(string: appConfiguration.apiBaseURL)!,
                                          queryParameters: ["api_key": appConfiguration.apiKey
//                                                            ,"date":"2023-03-24"
                                                           ]
        )

        let apiDataNetwork = DefaultNetworkService(config: config)
        return DefaultDataTransferService(with: apiDataNetwork)
    }()
    
    lazy var imageDataTransferService: DataTransferService = {
        let config = DefaultNetworkConfig()

        let apiDataNetwork = DefaultNetworkService(config: config)
        return DefaultDataTransferService(with: apiDataNetwork)
    }()
    
    lazy var apodResponseCache: APODResponseStorage = {
        UserDefaultResponseStorage()
    }()
}

