//
//  APODViewModel.swift
//  Astro
//
//  Created by Ganesh TR on 21/03/23.
//

import Foundation


class APODViewModel {
    let useCase: APODUseCase
    var aPod: Observable<APOD?> = Observable(.none)
    let error: Observable<String> = Observable("")
    
    var title: String? {
        aPod.value?.title
    }
    
    var explanation: String? {
        aPod.value?.explanation
    }
    
    var url: String? {
        if let isValidURL = aPod.value?.url.validUrl(), isValidURL {
            return aPod.value?.url
        }
        if let isValidThumbNailURL = aPod.value?.thumbnailURL.validUrl(), isValidThumbNailURL {
            return aPod.value?.thumbnailURL
        }
        return nil
    }
    
    var date: String? {
        aPod.value?.date
    }
    
    init(useCase: APODUseCase) {
        self.useCase = useCase
    }
    
    func fetchAPOD() {
        let request = APODRequest(thumb: true,
                                  date: Date().getDate())
        useCase.execute(requestValue: request) { cache in
            self.aPod.value = cache
        } completion: { result in
            switch result {
            case .success(let apod):
                self.aPod.value = apod
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
