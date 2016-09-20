//
//  RKDownloadRequest.swift
//  NetworkDemo
//
//  Created by gongruike on 16/9/20.
//  Copyright © 2016年 gongruike. All rights reserved.
//

import UIKit
import Alamofire

open class RKDownloadRequest<ResponseType, ResultType>: RKRequest<ResponseType, ResultType> {
    
    var downloadRequest: Alamofire.DownloadRequest? {
        return request as? Alamofire.DownloadRequest
    }
    
    var downloadResponse: Alamofire.DownloadResponse<ResponseType>?
    
    override open func prepare(_ requestQueue: RKRequestQueueType) {
        //
        super.prepare(requestQueue)        
    }
    
}
