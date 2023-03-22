//
//  AppFlowCoordinator.swift
//  Astro
//
//  Created by Ganesh TR on 22/03/23.
//

import UIKit

class AppFlowCoordinator {
    
    func start(navigationController: UINavigationController,
               diContainer: AppDIContainer) {
        let viewController = APODViewController
            .create(with: APODViewModel(service: diContainer.apiDataTransferService))
        navigationController.pushViewController(viewController, animated: true)
    }
}
