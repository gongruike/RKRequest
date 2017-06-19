//
//  BasicAuthClient.swift
//  Demo
//
//  Created by gongruike on 2017/6/19.
//  Copyright © 2017年 gongruike. All rights reserved.
//

import UIKit

class BasicAuthClient: RKRequestQueueDelegate {
    
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
        
        request.url = "http://localhost:3000/v1/" + request.url
        
        requestQueue.enqueue(request)
    }
    
    func requestQueue(_ requestQueue: RKRequestQueue, didStart request: RKRequestable) {
        
    }
    
    func requestQueue(_ requestQueue: RKRequestQueue, didFinish request: RKRequestable) {
        
        if request.request?.response?.statusCode == 401 {
            // 认证失败
            // do something
        }
        
    }
    
}
