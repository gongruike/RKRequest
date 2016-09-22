//
//  RKDataRequest.swift
//  NetworkDemo
//
//  Created by gongruike on 16/9/20.
//  Copyright © 2016年 gongruike. All rights reserved.
//

import UIKit
import Alamofire

open class RKDataRequest<ResponseType, ResultType>: RKRequest<ResponseType, ResultType> {
    
    var dataRequest: Alamofire.DataRequest? {
        return request as? Alamofire.DataRequest
    }
    
    var dataResponse: Alamofire.DataResponse<ResponseType>?
    
    override open func prepare(_ requestQueue: RKRequestQueueType) {
        //
        self.requestQueue = requestQueue
        //
        request = requestQueue.sessionManager.request(url,
                                                      method: method,
                                                      parameters: parameters,
                                                      encoding: encoding,
                                                      headers: headers)
    }
    
    open func dataProgress(queue: DispatchQueue = DispatchQueue.main, handler: @escaping RKProgressHandler) {
        //
        dataRequest?.downloadProgress(queue: queue, closure: { (progress) in
            //
            handler(progress)
        })
    }
    
}
