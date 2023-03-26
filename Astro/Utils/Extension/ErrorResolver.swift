//
//  ErrorResolver.swift
//  Astro
//
//  Created by Ganesh TR on 26/03/23.
//

import Foundation

extension DataTransferError {
    var isInternetConnectionError: Bool {
        guard case let DataTransferError.networkFailure(networkError) = self,
            case .notConnected = networkError else {
                return false
        }
        return true
    }
}
