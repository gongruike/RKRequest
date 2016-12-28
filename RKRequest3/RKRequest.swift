// The MIT License (MIT)
//
// Copyright (c) 2016 Ruike Gong
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

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


open class RKRequest<ResultType>: RKRequestable {

    public typealias RKCompletionHandler = (Alamofire.Result<ResultType>) -> Void
    
    public typealias RKProgressHandler = Alamofire.Request.ProgressHandler
    
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
    
    // Set requestQueue & generate request
    open func prepare(_ requestQueue: RKRequestQueueType) {
        // Overwrite by subclass
    }
    
    open func start() {
        //
        request?.resume()
        //
        parseResponseData()
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
         Parse data from server into ResponseType，
         ResponseType can be JSON, String, NSData, SwiftyJSON and so on.
     */
    func parseResponseData() {
        //
    }
    
    /*
         Parse response to the ResultType or generate a error
     */
    func parseResponse() -> Alamofire.Result<ResultType> {
        //
        return Alamofire.Result.failure(RKError.incorrectRequestType)
    }
    
    /*
         Deliver result or error in the main thread
     */
    func deliverResult() {
        //
        DispatchQueue.global(qos: .default).async {
            //
            let result = self.parseResponse()
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
