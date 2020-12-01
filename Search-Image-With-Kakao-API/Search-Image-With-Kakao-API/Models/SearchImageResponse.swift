//
//  SearchImageResponse.swift
//  Search-Image-With-Kakao-API
//
//  Created by klaus on 2020/12/02.
//  Copyright © 2020 yklaus. All rights reserved.
//

struct SearchImageResponse: Decodable {
    let message: String?
    let errorType: String?
    let meta: SearchImageResponseMeta?
    let documents: [SearchImageResponseDocument]?
}

struct SearchImageResponseMeta: Decodable {
    var isEnd: Bool
    let totalCount: Int
    let pageableCount: Int
}

struct SearchImageResponseDocument: Decodable {
    let width: Int
    let height: Int
    let datetime: String
    let imageUrl: String
    let thumbnailUrl: String
    let displaySitename: String
}
