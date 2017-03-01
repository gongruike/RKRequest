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

class BaseRequest<ResultType>: RKSwiftyJSONRequest<ResultType> {
    
    /*
    override func serializeRequest(in requestQueue: RKRequestQueueType) {
        // 在此处统一格式化请求
    }
     */
    
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

class UserListRequest: RKSwiftyJSONRequest<[User]> {
    
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

