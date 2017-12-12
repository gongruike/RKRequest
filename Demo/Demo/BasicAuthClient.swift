//
//  BasicAuthClient.swift
//  Demo
//
//  Created by gongruike on 2017/6/19.
//  Copyright © 2017年 gongruike. All rights reserved.
//

import UIKit

class BasicAuthClient: RequestQueueDelegate {
    
    static let shared = HTTPClient()
    
    private let requestQueue: RequestQueueType
    
    init() {
        let configuration = Configuration()
        
        requestQueue = RequestQueue(configuration: configuration)
        requestQueue.delegate = self
    }
    
    func startRequest(_ request: Requestable) {
        // 此处可做逻辑判断
        // 添加Authentication Header等
        request.headers["Authentication"] = "Bearer 1234567890kjhgf"
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
        
        if request.aRequest?.response?.statusCode == 401 {
            // 认证失败
            // do something
        }
        
    }
    
}
