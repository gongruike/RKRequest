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
    Type is the data type from server, like JSON, XML
    Value is the type that user-defined model of developer, like "User model", "Feed list", "Node info"
*/
open class RKRequest<Type, Vaule>: RKRequestable {

    public typealias RKCompletionHandler = (Result<Vaule>) -> Void
    
    open var url: URLConvertible
    
    open var method: HTTPMethod = .get
    
    open var parameters: Parameters = [:]
    
    open var encoding: ParameterEncoding = URLEncoding.default
    
    open var headers: HTTPHeaders = [:]
    
    open var request: Request?
    
    open var response: DataResponse<Type>?

    weak open var requestQueue: RKRequestQueueType?

    open var completionHandler: RKCompletionHandler?

    public init(url: URLConvertible, completionHandler: RKCompletionHandler?) {
        self.url = url
        self.completionHandler = completionHandler
    }
    
    open func serialize(in arequestQueue: RKRequestQueueType) {
        requestQueue = arequestQueue
        
        request = arequestQueue.sessionManager.request(
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
    }
    
    open func setDataParseHandler() {
        // Vary on different ResponseType
    }
    
    open func parseResponse(_ unserializedResponse: DataResponse<Type>) -> Result<Vaule> {
        return Result.failure(RKError.invalidRequestType)
    }
    
    open func deliverResult(_ result: Result<Vaule>? = nil) {
        DispatchQueue.global(qos: .default).async {
            
            let deliveredResult = result ?? ((self.response != nil) ? self.parseResponse(self.response!) : Result.failure(RKError.requestGenerationFailed))
            
            DispatchQueue.main.async {
                self.completionHandler?(deliveredResult)
            }
            
            self.requestQueue?.onRequestFinished(self)
        }
    }
    
}
