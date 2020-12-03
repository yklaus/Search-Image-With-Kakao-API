//
//  FullScreenImageViewModel.swift
//  Search-Image-With-Kakao-API
//
//  Created by klaus on 2020/12/02.
//  Copyright © 2020 yklaus. All rights reserved.
//

import CoreGraphics

final class FullScreenImageViewModel {
    weak var coordinator: FullScreenImageCoordinator?
    
    private var searchImageResponseDocument: SearchImageResponseDocument
    var onUpdate = {}
    
    var imageUrl: String {
        return searchImageResponseDocument.imageUrl
    }
    
    var displaySiteName: String {
        return searchImageResponseDocument.displaySitename
    }
    
    var datetime: String {
        return searchImageResponseDocument.datetime
    }
    
    init(_ searchImageResponseDocument: SearchImageResponseDocument) {
        self.searchImageResponseDocument = searchImageResponseDocument
    }
}

extension FullScreenImageViewModel {
    func viewDidLoad() {
        onUpdate()
    }
    
    func viewDidDisappear() {
        coordinator?.didFinish()
    }
    
    func calculateImageHeight(screenWidth: CGFloat?) -> CGFloat {
        if let screenWidth = screenWidth {
            return screenWidth * (CGFloat(searchImageResponseDocument.height) / CGFloat(searchImageResponseDocument.width))
        }
        
        return 0
    }
}
