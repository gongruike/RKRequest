//
//  HTTPClient.swift
//  Demo
//
//  Created by gongruike on 2017/3/1.
//  Copyright © 2017年 gongruike. All rights reserved.
//

import UIKit

class HTTPClient: RKRequestQueueDelegate {

    static let shared = HTTPClient()
    
    private let requestQueue: RKRequestQueueType

    init() {
        let configuration = RKConfiguration()
        
        requestQueue = RKRequestQueue(configuration: configuration)
        requestQueue.delegate = self
    }
    
    func startRequest(_ request: RKRequestable) {
        // 此处可做逻辑判断
        // 添加Authentication Header等

        request.headers["Authentication"] = "Bearer 1234567890kjhgf"
        
        do {
            let url = try request.url.asURL()
            request.url = URL(string: url.absoluteString, relativeTo: URL(string: "http://localhost:3000/v1/"))!
            
        } catch {
            // Handle error
            print(error)
        }
        requestQueue.enqueue(request)
        
    }
    
    func requestQueue(_ requestQueue: RKRequestQueue, didStart request: RKRequestable) {
        
    }
    
    func requestQueue(_ requestQueue: RKRequestQueue, didFinish request: RKRequestable) {
        
    }
    
}
