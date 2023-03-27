//
//  APODViewModel.swift
//  Astro
//
//  Created by Ganesh TR on 21/03/23.
//

import Foundation
import UIKit

protocol APODViewModelInput {
    func fetchAPOD()
}

protocol APODViewModelOutput {
    var aPod: Observable<APOD?> { get }
    var aPodImage: Observable<UIImage?> { get }
    var error: Observable<String?> { get }
    var title: String? { get }
    var explanation: String? { get }
    var image: UIImage? { get }
    var url: String? { get }
    var date: String? { get }
}

protocol APODViewModel: APODViewModelInput, APODViewModelOutput { }

class DefaultAPODViewModel: APODViewModel {
    private let useCase: APODUseCase
    private let imageRepository: ImageRepository?
    private(set) var aPod: Observable<APOD?> = Observable(.none)
    private(set) var aPodImage: Observable<UIImage?> = Observable(.none)
    private(set) var error: Observable<String?> = Observable(nil)
    
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
         imageRepository: ImageRepository?) {
        self.useCase = useCase
        self.imageRepository = imageRepository
    }
    
    func fetchAPOD() {
        fetchAPOD()
    }
    
    func fetchAPOD(with request: APODRequest = APODRequest(thumb: true, date: Date().getDate())) {
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
        imageRepository?.fetchImage(with: url) { result in
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
