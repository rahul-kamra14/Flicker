//
//  Result.swift
//  FlickerApp
//
//  Created by Rahul Kamra on 30/08/20.
//  Copyright © 2020 Rahul Kamra. All rights reserved.
//

import Foundation

enum Result <T>{
    case Success(T)
    case Failure(String)
    case Error(String)
}

