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

public protocol Requestable: class {
    
    var url: Alamofire.URLConvertible { get set }
    
    var method: Alamofire.HTTPMethod { get set }
    
    var parameters: Alamofire.Parameters { get set }
    
    var encoding: Alamofire.ParameterEncoding { get set }
    
    var headers: Alamofire.HTTPHeaders { get set }
    
    var timeoutInterval: TimeInterval { get set }
    
    var aRequest: Alamofire.Request? { get }
    
    func prepare(in requestQueue: RequestQueueType)
    
    func start()
    
    func cancel()
}

public protocol RequestQueueType: class {
    
    var sessionManager: SessionManager { get }
    
    weak var delegate: RequestQueueDelegate? { get set }
    
    func enqueue(_ request: Requestable)
    
    func dequeue() -> Requestable?
    
    func onRequestStarted(_ request: Requestable)
    
    func onRequestFinished(_ request: Requestable)
}

public protocol RequestQueueDelegate: class {
    
    func requestQueue(_ requestQueue: RequestQueue, didStart request: Requestable)
    
    func requestQueue(_ requestQueue: RequestQueue, didFinish request: Requestable)
}
