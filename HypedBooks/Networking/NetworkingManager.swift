//
//  NetworkingManager.swift
//  HypedBooks
//
//  Created by Natalia Nikitina on 12/7/17.
//  Copyright © 2017 Natalia Nikitina. All rights reserved.
//

import Alamofire

class NetworkingManager {

  static let shared = NetworkingManager()

  func makeRequest(target: Target, completion: @escaping (_ response: DataResponse<Any>) -> Void) {
    guard let urlParams = target.queryParams else { return }
    Alamofire.request(target.fullPath, method: target.method, parameters: urlParams,
                      encoding: URLEncoding.default, headers: target.headers).responseJSON { response in
                        completion(response)
    }
  }

}
