//
//  RKSwiftyJSONRequest.swift
//  Demo
//
//  Created by gongruike on 2017/3/1.
//  Copyright © 2017年 gongruike. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RKSwiftyJSONRequest<ResultType>: RKDataRequest<SwiftyJSON.JSON, ResultType> {

    override func setDataParseHandler() {
        //
        dataRequest?.responseSwiftyJSON(completionHandler: { (response) in
            //
            self.response = response
            //
            self.deliverResult()
        })
    }
    
}
