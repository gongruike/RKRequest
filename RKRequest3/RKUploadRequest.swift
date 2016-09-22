//
//  RKUploadRequest.swift
//  NetworkDemo
//
//  Created by gongruike on 16/9/20.
//  Copyright © 2016年 gongruike. All rights reserved.
//

import UIKit
import Alamofire

open class RKUploadRequest<ResponseType, ResultType>: RKDataRequest<ResponseType, ResultType> {
    
    open var uploadRequest: Alamofire.UploadRequest? {
        return request as? Alamofire.UploadRequest
    }
    
    override open func prepare(_ requestQueue: RKRequestQueueType) {
        //
        self.requestQueue = requestQueue
        // Alamofire中的upload方法太多了，还是不写了
    }
    
    open func uploadProgress(queue: DispatchQueue = DispatchQueue.main, closure: @escaping RKProgressHandler) {
        //
        uploadRequest?.uploadProgress(queue: queue, closure: closure)
    }
    
}

