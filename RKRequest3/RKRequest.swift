// The MIT License (MIT)
//
// Copyright (c) 2017 Ruike Gong
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

// ResponseType is the data type from server, like JSON, XML
// ResultType is the type that user-defined model of developer, like "User model", "Feed list", "Node info"

open class RKRequest<ResponseType, ResultType>: RKRequestable {

    public typealias RKCompletionHandler = (Result<ResultType>) -> Void
    
    open var url: URLConvertible
    
    open var method: HTTPMethod = .get
    
    open var parameters: Parameters = [:]
    
    open var encoding: ParameterEncoding = URLEncoding.default
    
    open var headers: HTTPHeaders = [:]

    open var request: Request?
    
    open var response: DataResponse<ResponseType>?

    open var requestQueue: RKRequestQueueType?

    open var completionHandler: RKCompletionHandler?

    public init(url: URLConvertible, completionHandler: RKCompletionHandler?) {
        //
        self.url = url
        self.completionHandler = completionHandler
    }
    
    //
    open func serializeRequest(in requestQueue: RKRequestQueueType) {
        //
        self.requestQueue = requestQueue
        //
        self.request = requestQueue.sessionManager.request(
            url,
            method: method,
            parameters: parameters,
            encoding: encoding,
            headers: headers
        )
    }
    
    open func start() {
        //
        guard let request = request else { return }
        //
        setDataParseHandler()
        //
        request.resume()
        //
        requestQueue?.onRequestStarted(self)
    }
    
    open func cancel() {
        //
        guard let request = request else { return }
        //
        request.cancel()
    }
    
    //
    open func setDataParseHandler() {
        // Vary on different ResponseType
    }
    
    //
    open func parseResponse(_ unserializedResponse: DataResponse<ResponseType>) -> Result<ResultType> {
        //
        return Result.failure(RKError.incorrectRequestType)
    }
    
    //
    open func deliverResult() {
        //
        DispatchQueue.global(qos: .default).sync {
            //
            let result = (self.response != nil) ? self.parseResponse(self.response!) : Result.failure(RKError.emptyResponse)
            //
            DispatchQueue.main.sync {
                //
                self.completionHandler?(result)
            }
            //
            self.requestQueue?.onRequestFinished(self)
        }
    }
    
}
