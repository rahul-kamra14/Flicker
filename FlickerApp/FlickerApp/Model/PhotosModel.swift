//
//  PhotoModel.swift
//  FlickerApp
//
//  Created by Rahul Kamra on 30/08/20.
//  Copyright © 2020 Rahul Kamra. All rights reserved.
//

import Foundation

struct SearchResultsModel: Codable {
    let stat: String?
    var photos: ResultsModel?
}

struct ResultsModel: Codable {
    var page: Int?
    var pages: Int?
    var perpage: Int?
    var total: String?
    var photo: [PhotosModel]?
}

struct PhotosModel: Codable {
    var id: String?
    var owner: String?
    var secret: String?
    var server: String?
    var farm: Int?
    var title: String?
    var ispublic: Int?
    var isfriend: Int?
    var isfamily: Int?

    func flickrImageURL(_ size: String = "m") -> String? {
        if
            let farm = self.farm,
            let server = self.server,
            let id = self.id,
            let secret = self.secret {
            let url =  "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_\(size).jpg"
            return url
        }
        return nil
    }
}
