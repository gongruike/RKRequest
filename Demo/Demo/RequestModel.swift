//
//  RequestModel.swift
//  Demo
//
//  Created by gongruike on 2017/3/1.
//  Copyright © 2017年 gongruike. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class User {
    
    let id: String
    
    let name: String
    
    init(attributes: SwiftyJSON.JSON) {
        //
        id = attributes["id"].stringValue
        name = attributes["name"].stringValue
    }
    
}


class UserInfoRequest: RKSwiftyJSONRequest<User> {
    
    override func parseResponse(_ response: DataResponse<SwiftyJSON.JSON>) -> Result<User> {
        //
        switch response.result {
        case .success(let value):
            return Result.success(User(attributes: value))
        case .failure(let error):
            return Result.failure(error)
        }
    }
    
}
