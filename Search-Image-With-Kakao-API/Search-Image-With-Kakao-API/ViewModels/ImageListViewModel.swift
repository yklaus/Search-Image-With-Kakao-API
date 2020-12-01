//
//  ImageListViewModel.swift
//  Search-Image-With-Kakao-API
//
//  Created by klaus on 2020/11/29.
//  Copyright © 2020 yklaus. All rights reserved.
//

import Moya

enum State {
    case resultNone
    case loading
    case error
    case ready
    case end
}

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
    private(set) var state: State = .ready
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
    
    func loadMore(_ indexPath: IndexPath) {
        if let meta = searchImageResponseMeta,
            !meta.isEnd,
            indexPath.item == cells.count - 1,
            state == .ready {
            loadMoreResult()
        }
    }
    
    func loadMoreResult() {
        if !query.isEmpty {
            state = .loading
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
                        
                        self.setState()
                        self.page += 1
                        self.onUpdate()
                    } catch {
                        self.state = .error
                        self.onUpdate()
                    }
                case .failure:
                    self.state = .error
                    self.page += 1
                    self.onUpdate()
                }
            }
        }
    }
    
    func setState() {
        if let meta = searchImageResponseMeta, meta.isEnd {
            state = .end
        } else if cells.count == 0 && page == 1 {
            state = .resultNone
        } else {
            state = .ready
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
