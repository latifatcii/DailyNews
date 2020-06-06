//
//  APIErrors.swift
//  DailyNews
//
//  Created by Latif Atci on 6/7/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//


enum NetworkResponse: String, Error {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}



