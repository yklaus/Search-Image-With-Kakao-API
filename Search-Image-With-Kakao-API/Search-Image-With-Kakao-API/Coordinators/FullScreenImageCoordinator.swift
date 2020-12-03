//
//  FullScreenImageCoordinator.swift
//  Search-Image-With-Kakao-API
//
//  Created by klaus on 2020/12/02.
//  Copyright © 2020 yklaus. All rights reserved.
//

import UIKit

final class FullScreenImageCoordinator: Coordinator {
    private(set) var childCoordinators: [Coordinator] = []
    private let navigationController: UINavigationController
    private let searchImageResponseDocument: SearchImageResponseDocument
    
    var parentCoordinator: ImageListCoordinator?
    
    init(searchImageResponseDocument: SearchImageResponseDocument, navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.searchImageResponseDocument = searchImageResponseDocument
    }
}

extension FullScreenImageCoordinator {
    func start() {
        let fullScreenImageViewController: FullScreenImageViewController = .instantiate()
        let fullScreenImageViewModel: FullScreenImageViewModel = FullScreenImageViewModel(searchImageResponseDocument)
        fullScreenImageViewModel.coordinator = self
        fullScreenImageViewController.viewModel = fullScreenImageViewModel
        navigationController.present(fullScreenImageViewController, animated: true, completion: nil)
    }
    
    func didFinish() {
        parentCoordinator?.childDidFinish(self)
    }
}
