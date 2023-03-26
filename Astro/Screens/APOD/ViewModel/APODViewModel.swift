//
//  APODViewModel.swift
//  Astro
//
//  Created by Ganesh TR on 21/03/23.
//

import Foundation
import UIKit

class APODViewModel {
    let useCase: APODUseCase
    let imageRepository: ImageRepository
    var aPod: Observable<APOD?> = Observable(.none)
    var aPodImage: Observable<UIImage?> = Observable(.none)
    let error: Observable<String> = Observable("")
    
    var title: String? {
        aPod.value?.title
    }
    
    var explanation: String? {
        aPod.value?.explanation
    }
    
    var image: UIImage? {
        aPodImage.value
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
    
    init(useCase: APODUseCase,
         imageRepository: ImageRepository) {
        self.useCase = useCase
        self.imageRepository = imageRepository
    }
    
    func fetchAPOD() {
        let request = APODRequest(thumb: true,
                                  date: Date().getDate())
        useCase.execute(requestValue: request){ apod, error in
            self.aPod.value = apod
            self.fetchImage()
            if let error = error as? DataTransferError,
                error.isInternetConnectionError {
                self.error.value = "We are not connected to the internet, showing you the last image we have."
            }
        }
    }
    
    func fetchImage() {
        guard let url = url else { return }
        imageRepository.fetchImage(with: url) { result in
            switch result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    self.aPodImage.value = image
                }
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
}
