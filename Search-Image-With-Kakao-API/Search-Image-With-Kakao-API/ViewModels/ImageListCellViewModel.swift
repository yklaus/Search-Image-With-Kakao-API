//
//  ImageListCellViewModel.swift
//  Search-Image-With-Kakao-API
//
//  Created by klaus on 2020/12/02.
//  Copyright © 2020 yklaus. All rights reserved.
//

struct ImageListCellViewModel {
    private var searchImageResponseDocument: SearchImageResponseDocument
    
    var thumbnailUrl: String {
        return searchImageResponseDocument.thumbnailUrl
    }
    
    var onSelect: (SearchImageResponseDocument) -> Void = { _ in }
    
    init(_ searchImageResponseDocument: SearchImageResponseDocument) {
        self.searchImageResponseDocument = searchImageResponseDocument
    }
}

extension ImageListCellViewModel {
    func didSelect() {
        onSelect(searchImageResponseDocument)
    }
}
