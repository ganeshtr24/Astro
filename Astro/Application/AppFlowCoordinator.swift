//
//  AppFlowCoordinator.swift
//  Astro
//
//  Created by Ganesh TR on 22/03/23.
//

import UIKit

class AppFlowCoordinator {
    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    init(navigationController: UINavigationController,
         appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }
    
    func start() {
        // We can check if user needs to authenticate and continue the login flow
        let vc = APODViewController.create(with: makeAPODViewMode())
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func makeAPODViewMode() -> APODViewModel {
        APODViewModel(useCase: makeAPODUseCase())
    }
    
    func makeAPODUseCase() -> APODUseCase {
        DefaultAPODUseCase(apodRepository: makeAPODRepository())
    }
                           
    func makeAPODRepository() -> DefaultAPODRepository {
        return DefaultAPODRepository(dataTransferService: self.appDIContainer.apiDataTransferService,
                                     cache: self.appDIContainer.apodResponseCache)
    }
        
}
