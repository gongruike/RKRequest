//
//  RKUtils.swift
//  NetworkDemo
//
//  Created by gongruike on 16/8/10.
//  Copyright © 2016年 gongruike. All rights reserved.
//

import UIKit


public enum RKError: Error {
    case nilRequest
    case incorrectRequestType
    case emptyResponse
}

extension RKError: LocalizedError {
    //
    public var errorDescription: String? {
        switch self {
        case .nilRequest:
            return ""
        case .incorrectRequestType:
            return "Incorrect request type, please use a valid request type"
        case .emptyResponse:
            return "Empty response"
        }
    }

}
