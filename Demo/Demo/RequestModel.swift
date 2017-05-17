//
//  RequestModel.swift
//  Demo
//
//  Created by gongruike on 2017/3/1.
//  Copyright © 2017年 gongruike. All rights reserved.
//

import Alamofire
import SwiftyJSON

class User {
    
    let id: String
    
    let name: String
    
    init(attributes: SwiftyJSON.JSON) {
        //
        id = attributes["id"].stringValue
        name = attributes["name"].stringValue
    }
    
}

struct MyError: Error {
    
    enum InsideErrorType {
        case one(String)
        case two(Int)
        case three(Array<String>)
        case four(Dictionary<String, String>)
    }
    
    let type: InsideErrorType
    
    let code: Int
    
    func getErrorInfo() -> String {
        switch self.type {
        case .one(let str):
            return str
        case .two(let number):
            return "\(number)"
        default:
            return "unknown error"
        }
    }
    
}

extension Error {
    
    func getErrorInfo() -> String {
        if let err = self as? MyError {
            return err.getErrorInfo()
        } else {
            return localizedDescription
        }
    }
    
}

class BaseRequest<Value>: RKSwiftyJSONRequest<Value> {
    
    override func serialize(in requestQueue: RKRequestQueueType) {
        //
        self.requestQueue = requestQueue
        
        do {
            let aURL = try url.asURL()
            url = URL(string: aURL.absoluteString, relativeTo: URL(string: "http://www.baidu.com"))!
            
            self.request = self.requestQueue?.sessionManager.request(
                url,
                method: method,
                parameters: parameters,
                encoding: encoding,
                headers: headers
            )
        } catch {
            //
            self.deliverResult(Result.failure(error))
        }
    }
    
}

class UserInfoRequest: BaseRequest<User> {
    
    init(userID: String, completionHandler: RKCompletionHandler?) {
        super.init(url: "/user/\(userID)", completionHandler: completionHandler)
    }
    
    override func parseResponse(_ unserializedResponse: DataResponse<JSON>) -> Result<User> {
        //
        switch unserializedResponse.result {
        case .success(let value):
            return Result.success(User(attributes: value))
        case .failure(let error):
            return Result.failure(error)
        }
    }
    
}

class UserListRequest: BaseRequest<[User]> {
    
    init(completionHandler: RKCompletionHandler?) {
        //
        super.init(url: "/users", completionHandler: completionHandler)
    }
    
    override func parseResponse(_ unserializedResponse: DataResponse<JSON>) -> Result<Array<User>> {
        //
        switch unserializedResponse.result {
        case .success(let value):
            return Result.success( value.map { User(attributes: $1) })
        case .failure(let error):
            return Result.failure(error)
        }
    }
    
}

class BaseListRequest<ResultType>: RKSwiftyJSONRequest<ResultType> {
    
    let pageNumber: Int
    
    let pageSize: Int
    
    init(pageNumber: Int, pageSize: Int, url: URLConvertible, completionHandler: RKCompletionHandler?) {
        self.pageNumber = pageNumber
        self.pageSize = pageSize
        //
        super.init(url: url, completionHandler: completionHandler)
    }
    
}


