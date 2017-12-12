//
//  HTTPClient.swift
//  Demo
//
//  Created by gongruike on 2017/3/1.
//  Copyright © 2017年 gongruike. All rights reserved.
//

import UIKit

class HTTPClient: RequestQueueDelegate {

    static let shared = HTTPClient()
    
    private let requestQueue: RequestQueueType

    init() {
        let configuration = Configuration()
        
        requestQueue = RequestQueue(configuration: configuration)
        requestQueue.delegate = self
    }
    
    func startRequest(_ request: Requestable) {
        do {
            _ = try request.url.asURL()
        } catch {
            request.url = "http://localhost:3000/v1/" + ""
        }
        requestQueue.enqueue(request)
    }
    
    func requestQueue(_ requestQueue: RequestQueue, didStart request: Requestable) {
        
    }
    
    func requestQueue(_ requestQueue: RequestQueue, didFinish request: Requestable) {
        
    }
    
}



