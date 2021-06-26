//
//  FlickrViewModel.swift
//  FlickerApp
//
//  Created by Rahul Kamra on 30/08/20.
//  Copyright © 2020 Rahul Kamra. All rights reserved.
//

import Foundation

class FlickerViewModel {
    
    private let service: FlickerServiceProtocol
    private(set) var photoArray = [PhotosModel]()
    private var searchText = ""
    private var pageNo = 1
    private var totalPageNo = 1
    
    var showAlert: ((String) -> Void)?
    var dataUpdated: (() -> Void)?
    
    init(service: FlickerServiceProtocol = FlickerService()) {
        self.service = service
    }
    
    func search(text: String, completion:@escaping () -> Void) {
        searchText = text
        photoArray.removeAll()
        fetchResults(completion: completion)
    }
    
    func fetchResults(completion:@escaping () -> Void) {
        service.fetchData(pageNo, searchText) { (result) in
            switch result {
            case .Success(let results):
                if let result = results {
                    self.totalPageNo = result.pages ?? 0
                    if let photos = result.photo {
                        self.photoArray.append(contentsOf: photos)
                    }
                    self.dataUpdated?()
                }
                completion()
            case .Failure(let message):
                self.showAlert?(message)
                completion()
            case .Error(let error):
                if self.pageNo > 1 {
                    self.showAlert?(error)
                }
                completion()
            }
        }
    }
    
    func fetchNextPage(completion:@escaping () -> Void) {
        if pageNo < totalPageNo {
            pageNo += 1
            fetchResults {
                completion()
            }
        } else {
            completion()
        }
    }
    
}
