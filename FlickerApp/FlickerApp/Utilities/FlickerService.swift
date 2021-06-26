//
//  FlickerService.swift
//  FlickerApp
//
//  Created by Rahul Kamra on 30/08/20.
//  Copyright © 2020 Rahul Kamra. All rights reserved.
//

import Foundation

protocol FlickerServiceProtocol {
    func fetchData(_ page: Int, _ searchText: String, completion: @escaping (Result<ResultsModel?>) -> Void)
}

class FlickerService: FlickerServiceProtocol {
    let networkClient: NetworkClientProtocol
    
    init(networkClient: NetworkClientProtocol = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    
    func fetchData(_ page: Int, _ searchText: String, completion: @escaping (Result<ResultsModel?>) -> Void) {
        let request = RequestProvider.search(page: page, text: searchText)
        networkClient.request(request) { (result) in
            switch result {
            case .Success(let data):
                if let model = data.getType(SearchResultsModel.self){
                    if let stat = model.stat, stat.uppercased().contains("OK") {
                        return completion(.Success(model.photos))
                    }
                }else {
                    return completion(.Failure("Error"))
                }
            case .Failure(let error):
                completion(.Failure(error.description))
            case .Error(let error):
                completion(.Failure(error.description))
            }
        }
    }
}

extension Data {
    
    func getType<T: Codable>(_ decodingType: T.Type) -> T? {
        do {
            let responseModel = try JSONDecoder().decode(T.self, from: self)
            return responseModel
        } catch {
            print("Data parsing error: \(error.localizedDescription)")
            return nil
        }
    }
    
}
