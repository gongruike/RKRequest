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

public protocol RKRequestable: class {
    
    var url: URLConvertible { get set }
    
    var method: HTTPMethod { get set }
    
    var parameters: Parameters { get set }
    
    var encoding: ParameterEncoding { get set }
    
    var headers: HTTPHeaders { get set }
    
    var request: Request? { get }
    
    func serialize(in requestQueue: RKRequestQueueType)
    
    func start()
    
    func cancel()
}

public protocol RKRequestQueueType: class {
    
    var sessionManager: SessionManager { get }
    
    weak var delegate: RKRequestQueueDelegate? { get set }
    
    func enqueue(_ request: RKRequestable)
    
    func dequeue() -> RKRequestable?
    
    func onRequestStarted(_ request: RKRequestable)
    
    func onRequestFinished(_ request: RKRequestable)
}

public protocol RKRequestQueueDelegate: class {
    
    func requestQueue(_ requestQueue: RKRequestQueue, didStart request: RKRequestable)
    
    func requestQueue(_ requestQueue: RKRequestQueue, didFinish request: RKRequestable)
}
