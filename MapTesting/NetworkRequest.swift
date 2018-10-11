//
//  NetworRequest.swift
//  MapTesting
//
//  Created by Camilo Rivas on 01-03-18.
//  Copyright © 2018 Camilo Rivas. All rights reserved.
//

import Foundation

protocol NetworkRequest : class {
    associatedtype Model
    func load(withCompletion completion: @escaping (Model?) -> Void)
    func decode(_ data: Data) -> Model?
}

extension NetworkRequest {
    fileprivate func load(_ url: URL, method: String, body: Data?, withCompletion completion: @escaping (Model?) -> Void) {
        let configuration = URLSessionConfiguration.ephemeral
        
        var urlrequest = URLRequest(url: url)
        urlrequest.httpBody = body
        urlrequest.httpMethod = method
        
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: urlrequest, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let data = data else {
                completion(nil)
                return
            }
            completion(self.decode(data))
        })
        task.resume()
    }
}
class StationsRequest {
    let url : URL
    
    init(url: URL) {
        self.url = url
    }
}
extension StationsRequest: NetworkRequest {
    func load(withCompletion completion: @escaping (Stations?) -> Void) {
        load(url, method: "GET", body: nil, withCompletion: completion)
    }
    
    func decode(_ data: Data) -> Stations? {
        guard let stations = try? JSONDecoder().decode(Stations.self, from: data) else {
            return nil
        }
        return stations
    }
}
