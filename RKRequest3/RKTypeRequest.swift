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

/*
    Take advantages of Alamofire
 */
open class RKStringTypeRequest<Vaule>: RKDataRequest<String, Vaule> {
    
    open override func setDataParseHandler() {
        dataRequest?.responseString(completionHandler: { stringResponse -> Void in
            self.response = stringResponse
            self.deliverResult()
        })
    }
    
}

open class RKJSONTypeRequest<Vaule>: RKDataRequest<Any, Vaule> {
    
    open override func setDataParseHandler() {
        dataRequest?.responseJSON(completionHandler: { jsonResponse -> Void in
            self.response = jsonResponse
            self.deliverResult()
        })
    }
    
}

open class RKDataTypeRequest<Vaule>: RKDataRequest<Data, Vaule> {
    
    open override func setDataParseHandler() {
        dataRequest?.responseData(completionHandler: { dataResponse -> Void in
            self.response = dataResponse
            self.deliverResult()
        })
    }
    
}


