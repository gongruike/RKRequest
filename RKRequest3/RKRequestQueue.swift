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

open class RKRequestQueue: RKRequestQueueType {
    
    open let sessionManager: SessionManager
    
    open let configuration: RKConfiguration
    
    weak open var delegate: RKRequestQueueDelegate?

    open var activeRequestCount: Int = 0
    
    open var queuedRequests: [RKRequestable] = []
    
    let synchronizationQueue = DispatchQueue(label: "cn.rk.request.synchronization.queue." + UUID().uuidString)
    
    public init(configuration: RKConfiguration) {
        self.configuration = configuration
        self.sessionManager = SessionManager(
            configuration: configuration.configuration,
            delegate: SessionDelegate(),
            serverTrustPolicyManager: configuration.trustPolicyManager
        )
        // Important
        self.sessionManager.startRequestsImmediately = false
    }
    
    open func enqueue(_ request: RKRequestable) {
        //
        synchronizationQueue.async { [weak self] in
            guard let strongSelf = self else { return }
            
            if strongSelf.isActiveRequestCountBelowMaximumLimit() {
                strongSelf.start(request)
            } else {
                strongSelf.enqueueRequest(request)
            }
        }
    }
    
    open func dequeue() -> RKRequestable? {
        //
        var request: RKRequestable?
        if !queuedRequests.isEmpty {
            request = queuedRequests.removeFirst()
        }
        return request
    }

    private func start(_ request: RKRequestable) {
        //
        request.serialize(in: self)
        request.start()
    }
    
    private func startNextRequest() {
        //
        guard isActiveRequestCountBelowMaximumLimit() else { return }
        guard let request = dequeue() else { return }
        
        start(request)
    }
    
    private func enqueueRequest(_ request: RKRequestable) {
        //
        switch configuration.prioritization {
        case .fifo:
            queuedRequests.append(request)
        case .lifo:
            queuedRequests.insert(request, at: 0)
        }
    }
    
    private func isActiveRequestCountBelowMaximumLimit() -> Bool {
        return activeRequestCount < configuration.maximumActiveRequestCount
    }
    
    open func onRequestStarted(_ request: RKRequestable) {
        activeRequestCount += 1
        
        DispatchQueue.main.async {
            self.delegate?.requestQueue(self, didStart: request)
        }
    }
    
    open func onRequestFinished(_ request: RKRequestable) {
        synchronizationQueue.async { [weak self] in
            guard let strongSelf = self else { return }
            
            if strongSelf.activeRequestCount > 0 {
                strongSelf.activeRequestCount -= 1
            }
            strongSelf.startNextRequest()
        }
        
        DispatchQueue.main.async {
            self.delegate?.requestQueue(self, didFinish: request)
        }
    }
    
}
