//
//  RKSwiftyJSONRequest.swift
//  Demo
//
//  Created by gongruike on 2017/3/1.
//  Copyright © 2017年 gongruike. All rights reserved.
//

import Alamofire
import SwiftyJSON
import AlamofireSwiftyJSON

class RKSwiftyJSONRequest<ResultType>: RKDataRequest<SwiftyJSON.JSON, ResultType> {

    override func setDataParseHandler() {
        //
        dataRequest?.responseSwiftyJSON(completionHandler: { dateResponse in
            //
            self.response = dateResponse
            //
            self.deliverResult()
        })
    }
    
}
