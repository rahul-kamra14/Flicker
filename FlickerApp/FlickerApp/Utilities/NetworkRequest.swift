//
//  NetworkRequest.swift
//  FlickerApp
//
//  Created by Rahul Kamra on 30/08/20.
//  Copyright © 2020 Rahul Kamra. All rights reserved.
//

import Foundation

protocol UrlRequestProviderProtocol {
    var urlRequest : URLRequest? { get }
}
enum RequestProvider : UrlRequestProviderProtocol {
    case search(page : Int, text: String)
    
    private var apiKey : String {
        return "3e7cc266ae2b0e0d78e279ce8e361736"
    }
    
    private var url : URL? {
        switch self {
        case .search(let pageNumber, let searchText):
            let urlString =
            "http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&%20format=json&nojsoncallback=1&safe_search=1&text=\(searchText)&page=\(pageNumber)"
            let searchUrl = URL.init(string: urlString)
            return searchUrl
        }
    }
    var urlRequest : URLRequest? {
        guard let urlForRequest = self.url else {
            return nil
        }
        switch self {
        case .search(_,_):
            return URLRequest.init(url: urlForRequest)
        }
    }
    
}
