//
//  ImageListViewModel.swift
//  Search-Image-With-Kakao-API
//
//  Created by klaus on 2020/11/29.
//  Copyright © 2020 yklaus. All rights reserved.
//

import Foundation

final class ImageListViewModel {
    var query: String = "" {
        didSet {
            self.searchImage()
        }
    }
}

extension ImageListViewModel {
    func searchImage() {
    }
}
