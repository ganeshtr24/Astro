//
//  APODMockUseCase.swift
//  AstroTests
//
//  Created by Ganesh TR on 27/03/23.
//

import Foundation
@testable import Astro

class APODMockUseCase: APODUseCase {
    
    let pod: APOD?
    let error: Error?
    
    init(pod: APOD?, error: Error?) {
        self.pod    = pod
        self.error  = error
    }
    
    func execute(requestValue: Astro.APODRequest,
                 completion: @escaping (Astro.APOD?, Error?) -> Void) {
        completion(pod, error)
    }
}
