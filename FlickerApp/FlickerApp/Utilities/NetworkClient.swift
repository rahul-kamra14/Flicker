//
//  NetworkClient.swift
//  FlickerApp
//
//  Created by Rahul Kamra on 30/08/20.
//  Copyright © 2020 Rahul Kamra. All rights reserved.
//

import Foundation

protocol NetworkClientProtocol {
    func request(_ request: UrlRequestProviderProtocol, completion: @escaping (Result<Data>) -> Void)
}

class NetworkClient: NetworkClientProtocol {
    private var session = URLSession.shared
    
    func request(_ request: UrlRequestProviderProtocol, completion: @escaping (Result<Data>) -> Void) {
        guard let request = request.urlRequest else {
            return
        }
        
        session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            guard error == nil else {
                return completion(.Failure(error!.localizedDescription))
            }
            
            guard let data = data else {
                return completion(.Failure(error?.localizedDescription ?? ""))
            }
            
            guard let stringResponse = String(data: data, encoding: String.Encoding.utf8) else {
                return completion(.Failure(error?.localizedDescription ?? ""))
            }
            
            print("Respone: \(stringResponse)")
            
            return completion(.Success(data))
            
        }.resume()
    }
    
}
