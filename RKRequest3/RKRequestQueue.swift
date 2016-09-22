//
//  RKRequestQueueType.swift
//  NetworkDemo
//
//  Created by gongruike on 16/9/20.
//  Copyright © 2016年 gongruike. All rights reserved.
//

import UIKit
import Alamofire

public protocol RKRequestQueueType {
    //
    var sessionManager: Alamofire.SessionManager { get }
    //
    var configuration: RKConfiguration { get }
    //
    func onSendRequest(_ request: RKRequestable)
    //
    func onFinishRequest(_ request: RKRequestable)
}

open class RKRequestQueue: RKRequestQueueType {
    //
    open let sessionManager: Alamofire.SessionManager
    //
    open let configuration: RKConfiguration
    //
    open var activeRequestCount: Int = 0
    //
    open var queuedRequests: [RKRequestable] = []
    //
    let synchronizationQueue: DispatchQueue = {
        let name = String(format: "cn.rk.data.request.synchronization.queue-%08%08", arc4random(), arc4random())
        return DispatchQueue(label: name)
    }()
    
    public init(configuration: RKConfiguration) {
        //
        self.configuration = configuration
        //
        self.sessionManager = Alamofire.SessionManager(configuration: configuration.configuration,
                                                       delegate: Alamofire.SessionDelegate(),
                                                       serverTrustPolicyManager: configuration.trustPolicyManager)
        // Important
        self.sessionManager.startRequestsImmediately = false
    }
    
    open func addRequest(_ request: RKRequestable) {
        //
        synchronizationQueue.sync {
            //
            if self.isActiveRequestCountBelowMaximumLimit() {
                //
                self.startRequest(request)
            } else {
                //
                self.enqueueRequest(request)
            }
        }
    }

    open func startRequest(_ request: RKRequestable) {
        //
        request.prepare(self)
        //
        request.start()
        //
        self.activeRequestCount += 1
    }
    
    open func startNextRequest() {
        //
        guard isActiveRequestCountBelowMaximumLimit() else { return }
        //
        if let request = dequeueRequest() {
            //
            startRequest(request)
        }
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
    
    private func dequeueRequest() -> RKRequestable? {
        //
        var request: RKRequestable?
        //
        if !queuedRequests.isEmpty {
            request = queuedRequests.removeFirst()
        }
        //
        return request
    }
    
    private func isActiveRequestCountBelowMaximumLimit() -> Bool {
        //
        return activeRequestCount < configuration.maximumActiveRequestCount
    }
    
    public func onSendRequest(_ request: RKRequestable) {
        
    }
    
    public func onFinishRequest(_ request: RKRequestable) {
        
    }
    
}

