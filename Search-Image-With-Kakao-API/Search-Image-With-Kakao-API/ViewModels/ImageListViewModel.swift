//
//  ImageListViewModel.swift
//  Search-Image-With-Kakao-API
//
//  Created by klaus on 2020/11/29.
//  Copyright © 2020 yklaus. All rights reserved.
//

import Moya

final class ImageListViewModel {
    var query: String = "" {
        didSet {
            self.searchImage()
        }
    }
    
    var page = 1
    var onUpdate = {}
    var searchImageResponseMeta: SearchImageResponseMeta?
    
    enum Cell {
        case image(ImageListCellViewModel)
    }
    
    private(set) var cells: [Cell] = []
    private let networkProvider: MoyaProvider<DaumImageSearchApi>
    
    init(_ networkProvider: MoyaProvider<DaumImageSearchApi>) {
        self.networkProvider = networkProvider
    }
}

extension ImageListViewModel {
    func searchImage() {
        page = 1
        cells = []
        loadMoreResult()
    }
    
    func loadMoreResult() {
        if !query.isEmpty {
            networkProvider.request(.searchImage(query: self.query, page: 1)) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let response):
                    let responseData = response.data
                    do {
                        let jsonDecoder = JSONDecoder()
                        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                        let decoded = try jsonDecoder.decode(SearchImageResponse.self, from: responseData)
                        
                        self.searchImageResponseMeta = decoded.meta
                        if let documents = decoded.documents {
                            self.cells += documents.map {
                                let cellViewModel = ImageListCellViewModel($0)
                                return .image(cellViewModel)
                            }
                        }
                        
                        self.page += 1
                        self.onUpdate()
                    } catch {
                        self.onUpdate()
                    }
                case .failure(let error):
                    print("error: \(error)")
                    self.page += 1
                    self.onUpdate()
                }
            }
        }
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
