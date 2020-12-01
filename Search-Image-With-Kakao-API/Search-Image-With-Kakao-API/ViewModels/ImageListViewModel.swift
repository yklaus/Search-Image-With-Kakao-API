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
    var page = 1
    var onUpdate = {}
    
    enum Cell {
        case image(ImageListCellViewModel)
    }
    
    private(set) var cells: [Cell] = []
}

extension ImageListViewModel {
    func viewDidLoad() {
        searchImage()
    }
    
    func searchImage() {
        page = 1
        cells = []
        loadMoreResult()
    }
    
    func loadMoreResult() {
        // 이미지 검색 API 호출
    }
}

extension ImageListViewModel {
    func numberOfItems() -> Int {
        return cells.count
    }
    
    func cell(at indexPath: IndexPath) -> Cell {
        return cells[indexPath.item]
    }
}
