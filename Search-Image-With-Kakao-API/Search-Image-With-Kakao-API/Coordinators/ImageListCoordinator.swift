//
//  ImageListCoordinator.swift
//  Search-Image-With-Kakao-API
//
//  Created by klaus on 2020/11/29.
//  Copyright © 2020 yklaus. All rights reserved.
//

import UIKit
import Moya

final class ImageListCoordinator: Coordinator {
    private(set) var childCoordinators: [Coordinator] = []
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

extension ImageListCoordinator {
    func start() {
        let imageListViewController: ImageListViewController = .instantiate()
        let imageListViewModel = ImageListViewModel(MoyaProvider<DaumImageSearchApi>())
        imageListViewModel.coordinator = self
        imageListViewController.viewModel = imageListViewModel
        navigationController.setViewControllers([imageListViewController], animated: false)
    }
    
    func onSelect(_ searchImageResponseDocument: SearchImageResponseDocument) {
        let fullScreenImageCoordinator = FullScreenImageCoordinator(
            searchImageResponseDocument: searchImageResponseDocument,
            navigationController: navigationController
        )
        fullScreenImageCoordinator.parentCoordinator = self
        childCoordinators.append(fullScreenImageCoordinator)
        fullScreenImageCoordinator.start()
    }
    
    func childDidFinish(_ coordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: {
            return $0 === coordinator
        }) {
            childCoordinators.remove(at: index)
        }
    }
}
