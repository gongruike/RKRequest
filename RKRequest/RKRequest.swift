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
open class RKRequest<Type, Value>: RKRequestable {

    public typealias RKCompletionHandler = (Result<Value>) -> Void
    
    open var url: String
    
    open var method: HTTPMethod = .get
    
    open var parameters: Parameters = [:]
    
    open var encoding: ParameterEncoding = URLEncoding.default
    
    open var headers: HTTPHeaders = [:]
    
    open var request: Request?
    
    open var response: DataResponse<Type>?

    open var requestQueue: RKRequestQueueType?

    open var completionHandler: RKCompletionHandler?

    public init(url: String, completionHandler: RKCompletionHandler?) {
        
        self.url = url
        self.completionHandler = completionHandler
    }
    
    open func prepare(in aRequestQueue: RKRequestQueueType) {
        requestQueue = aRequestQueue
        
        request = aRequestQueue.sessionManager.request(
            url,
            method: method,
            parameters: parameters,
            encoding: encoding,
            headers: headers
        )
    }
    
    open func start() {
        setDataParseHandler()
        
        request?.resume()
        
        requestQueue?.onRequestStarted(self)
    }
    
    open func cancel() {
        request?.cancel()
        
        deliverResult(Result.failure(RKError.requestCanceled))
    }
    
    open func setDataParseHandler() {
        // Different Type
    }
    
    open func parseResponse(_ dataResponse: DataResponse<Type>) -> Result<Value> {
        return Result.failure(RKError.invalidRequestType)
    }
    
    open func deliverResult(_ result: Result<Value>? = nil) {
        DispatchQueue.global(qos: .default).async {
            
            let finalResult = result ?? ((self.response != nil) ? self.parseResponse(self.response!) : Result.failure(RKError.requestGenerationFailed))
            
            DispatchQueue.main.async {
                self.completionHandler?(finalResult)
            }
            
            self.requestQueue?.onRequestFinished(self)
        }
    }
    
}
