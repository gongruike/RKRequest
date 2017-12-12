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

import Alamofire

/*
    Type is the data type from server, like JSON, XML, String, Data,
    Value is the type that user-defined model, like "User model", "Feed list", "Node info"
*/
open class Request<Type, Value>: Requestable {

    public typealias CompletionHandler = (Result<Value>) -> Void
    
    open var url: Alamofire.URLConvertible
    
    open var method: Alamofire.HTTPMethod = .get
    
    open var parameters: Alamofire.Parameters = [:]
    
    open var encoding: Alamofire.ParameterEncoding = URLEncoding.default
    
    open var headers: Alamofire.HTTPHeaders = [:]
    
    open var timeoutInterval: TimeInterval = 10;
    
    open var aRequest: Alamofire.Request?
    
    open var response: Alamofire.DataResponse<Type>?

    open var requestQueue: RequestQueueType?

    open var completionHandler: CompletionHandler?

    public init(url: String, completionHandler: CompletionHandler?) {
        self.url = url
        self.completionHandler = completionHandler
    }
    
    open func prepare(in aRequestQueue: RequestQueueType) {
        requestQueue = aRequestQueue
        do {
            let originalRequest = try URLRequest(url: url, method: method, headers: headers)
            var encodedURLRequest = try encoding.encode(originalRequest, with: parameters)
            encodedURLRequest.timeoutInterval = timeoutInterval
            aRequest = aRequestQueue.sessionManager.request(encodedURLRequest);
        } catch {
            aRequest = aRequestQueue.sessionManager.request(
                url,
                method: method,
                parameters: parameters,
                encoding: encoding,
                headers: headers
            )
        }
    }
    
    open func start() {
        setResponseHandler()
        
        aRequest?.resume()
        
        requestQueue?.onRequestStarted(self)
    }
    
    open func cancel() {
        aRequest?.cancel()
    }
    
    open func setResponseHandler() {
        // Different Type
    }
    
    open func parse(_ dataResponse: DataResponse<Type>) -> Result<Value> {
        return Result.failure(RKError.invalidRequestType)
    }
    
    open func deliver(_ dataResponse: DataResponse<Type>) {
        //
        self.response = dataResponse;
        //
        DispatchQueue.global(qos: .default).async {
            
            let result = self.parse(dataResponse);
            
            DispatchQueue.main.async {
                self.completionHandler?(result)
            }
            
            self.requestQueue?.onRequestFinished(self)
        }
    }
    
}
