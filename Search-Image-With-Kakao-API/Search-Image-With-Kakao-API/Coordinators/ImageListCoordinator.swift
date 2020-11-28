//
//  ImageListCoordinator.swift
//  Search-Image-With-Kakao-API
//
//  Created by klaus on 2020/11/29.
//  Copyright © 2020 yklaus. All rights reserved.
//

import UIKit

final class ImageListCoordinator: Coordinator {
    private(set) var childCoordinators: [Coordinator] = []
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let imageListViewController: ImageListViewController = .instantiate()
        let imageListViewModel = ImageListViewModel()
        imageListViewController.viewModel = imageListViewModel
        navigationController.setViewControllers([imageListViewController], animated: false)
    }
}
