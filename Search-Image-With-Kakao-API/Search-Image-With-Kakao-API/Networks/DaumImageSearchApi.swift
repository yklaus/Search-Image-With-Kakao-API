//
//  DaumImageSearchApi.swift
//  Search-Image-With-Kakao-API
//
//  Created by klaus on 2020/12/02.
//  Copyright © 2020 yklaus. All rights reserved.
//

import Moya

private extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}

enum DaumImageSearchApi {
    case searchImage(query: String?, page: Int)
}

extension DaumImageSearchApi: TargetType {
    var baseURL: URL {
        return URL(string: "https://dapi.kakao.com/v2/search/image")!
    }
    
    var path: String {
        return ""
    }
    
    var method: Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .searchImage(let query, let page):
            var parameters: [String: Any] = ["page": page, "per_page": 30]
            if let query = query, !query.isEmpty {
                parameters["query"] = query.urlEscaped
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Authorization": "KakaoAK 30b84421245311b92b8288dd508c4efc"]
    }
    
    
}
