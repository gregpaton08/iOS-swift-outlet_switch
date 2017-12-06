//
//  OutletSwitch.swift
//  Outlet Switch
//
//  Created by Greg Paton on 12/6/17.
//  Copyright © 2017 GSP. All rights reserved.
//

import Foundation

public class OutletSwitch {
    
    public var address = ""
    
    public init() {
        
    }
    
    public var statusRequestState: URLSessionTask.State {
        get {
            return getDataTask?.state ?? .completed
        }
    }
    
    public func cancelStatusRequest() {
        getDataTask?.cancel()
    }
    
    private let statusSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 3
        return URLSession.init(configuration: config)
    }()
    private var getDataTask: URLSessionDataTask?
    
    private func getLockStatusUrl() -> URL? {
        return URL(string: "http://" + address + "/api/v1/lock_status")
    }
    
    public func getStatus(_ callbackFunction: @escaping (Bool?, Error?) -> Void) {
        // If the request is already in progress then don't request again.
        if getDataTask?.state == .running {
            return
        }
        
        getDataTask = statusSession.dataTask(with: getLockStatusUrl()!) { (data, response, error) in
            var lockStatus: Bool?
            if error == nil {
                let json = try? JSONSerialization.jsonObject(with: data!, options: [])
                if let dictionary = json as? [String: Any] {
                    lockStatus = dictionary["status"] as? Bool
                }
            }
            callbackFunction(lockStatus, error)
        }
        
        getDataTask?.resume()
    }
    
    public func setStatus(_ status: Bool, callback completionHandler: @escaping () -> Void) {
        let dataString = status ? "{\"status\":true}" : "{\"status\":false}"
        
        // Create a PUT request.
        var request = URLRequest(url: getLockStatusUrl()!)
        request.httpMethod = "PUT"
        request.timeoutInterval = 3.0
        
        // Add the JSON data to the request.
        let jsonData = dataString.data(using: String.Encoding.utf8)
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(String(describing: jsonData?.count), forHTTPHeaderField: "Content-Length")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            completionHandler()
        }
        
        task.resume()
    }
}
