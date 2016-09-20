//
//  RKBaseDataRequest.swift
//  NetworkDemo
//
//  Created by gongruike on 16/9/18.
//  Copyright © 2016年 gongruike. All rights reserved.
//

import UIKit
import Alamofire

public protocol RKRequestable {
    //
    var url: Alamofire.URLConvertible { get }
    //
    var method: Alamofire.HTTPMethod { get }
    //
    var parameters: Alamofire.Parameters { get }
    //
    var encoding: Alamofire.ParameterEncoding { get }
    //
    var headers: Alamofire.HTTPHeaders { get }
    //
    var requestQueue: RKRequestQueueType? { get }
    //
    func prepare(_ requestQueue: RKRequestQueueType)
    //
    func start()
    //
    func cancel()
}

open class RKRequest<ResponseType, ResultType>: RKRequestable {

    public typealias RKResult = Alamofire.Result<ResultType>

    public typealias RKCompletionHandler = (RKResult) -> Void
    
    open var url: Alamofire.URLConvertible
    
    open var method: Alamofire.HTTPMethod = .get
    
    open var parameters: Alamofire.Parameters = [:]
    
    open var encoding: Alamofire.ParameterEncoding = URLEncoding.default
    
    open var headers: Alamofire.HTTPHeaders = [:]

    open var request: Alamofire.Request?
    
    open var requestQueue: RKRequestQueueType?

    open var completionHandler: RKCompletionHandler?

    init(url: Alamofire.URLConvertible, completionHandler: RKCompletionHandler?) {
        //
        self.url = url
        self.completionHandler = completionHandler
    }
    
    // Set requestQueue & generate Request
    open func prepare(_ requestQueue: RKRequestQueueType) {
        //
        self.requestQueue = requestQueue
    }
    
    open func start() {
        //
        request?.resume()
        //
        requestQueue?.onSendRequest(self)
    }
    
    open func cancel() {
        //
        request?.cancel()
        //
        deliverResult()
    }
    
    /*
         Parse the data from server into ResponseType，
         ResponseType can be JSON, String, NSData, SwiftyJSON and so on.
     */
    func parseDataResponse() {
        //
    }
    
    /*
         Parse response to the final ResultType or generate a error
     */
    func parseResult() -> RKResult {
        //
        return RKResult.failure(RKError.IncorrectRequestTypeError)
    }
    
    /*
         Deliver result or error in the main thread
     */
    func deliverResult() {
        //
        DispatchQueue.global(qos: .default).async {
            //
            let result = self.parseResult()
            //
            DispatchQueue.main.async {
                //
                self.completionHandler?(result)
            }
            //
            self.requestQueue?.onFinishRequest(self)
        }
    }
}

extension RKRequest: CustomStringConvertible {
    
    public var description: String {
        //
        return request?.description ?? ""
    }
}

extension RKRequest: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        //
        return request?.debugDescription ?? ""
    }
}

