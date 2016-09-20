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
    
    var uploadRequest: Alamofire.UploadRequest? {
        return request as? Alamofire.UploadRequest
    }
    
    override open func prepare(_ requestQueue: RKRequestQueueType) {
        //
        super.prepare(requestQueue)
    }
    
}
