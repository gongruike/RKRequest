//
//  RKUtils.swift
//  NetworkDemo
//
//  Created by gongruike on 16/8/10.
//  Copyright © 2016年 gongruike. All rights reserved.
//

import UIKit


public enum RKError: Error {
    case incorrectRequestTypeError
    case emptyResponseError
}

extension RKError: LocalizedError {
    //
    public var errorDescription: String? {
        switch self {
        case .incorrectRequestTypeError:
            return "Incorrect request type, please use a valid request type"
        case .emptyResponseError:
            return "Empty response"
        }
    }

}
