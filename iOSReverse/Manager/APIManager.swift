//
//  APIManager.swift
//  iOSReverse
//
//  Created by 马旭 on 2018/2/12.
//  Copyright © 2018年 iosre.com. All rights reserved.
//

import Foundation

enum ManagerError: Error {
  case failedRequest
  case invalidResponse
  case unknown
}

final class APIManager {
  private let baseURL: URL
  private init(baseURL: URL) {
    self.baseURL = baseURL
  }
  
  static let shared = APIManager(baseURL: API.baseURL)
  
  typealias CompletionHandler = (Category?, ManagerError?) -> Void
  
  func categoryList(completion: @escaping CompletionHandler) -> Void {
    let url = baseURL.appendingPathComponent("categories.json")
    var request = URLRequest(url: url);
    
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "GET"
    
    URLSession.shared.dataTask(with: request) { (data, res, err) in
      DispatchQueue.main.async {
        self.disFinishGettingCategory(data: data, response: res, error: err, completion: completion)
      }
    }
  }
  
  func disFinishGettingCategory(data: Data?, response: URLResponse?, error: Error?, completion: CompletionHandler) {
    if let _ = error {
      completion(nil, .failedRequest)
    }
    else if let data = data, let res = response as? HTTPURLResponse {
      if res.statusCode == 200 {
        do {
          let data = try JSONDecoder().decode(Category.self, from: data)
          completion(data, nil)
        }
        catch {
          completion(nil, .invalidResponse)
        }
      }
      else {
        completion(nil, .failedRequest)
      }
    }
    else {
      completion(nil, .unknown)
    }
  }
  
}
