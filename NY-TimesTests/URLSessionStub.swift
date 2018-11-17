//
//  URLSessionStub.swift
//  NY-TimesTests
//
//  Created by Udit Batra on 17/11/18.
//  Copyright © 2018 Udit Batra. All rights reserved.
//

import UIKit

import Foundation

@testable import NY_Times

struct URLDataTaskResponse {
    var data : Data?
    var urlResponse : URLResponse!
    var error : Error?
}

class URLSessionStub : URLSessionProtocol{
    
    var response : URLDataTaskResponse!
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return URLSessionDataTaskStub.init(response: response, completionHandler: completionHandler)
    }
    
    
}

class URLSessionDataTaskStub: URLSessionDataTask {
    
    var testrResponse : URLDataTaskResponse
    var completionHandler : (Data?, URLResponse?, Error?) -> Void
    
    init(response : URLDataTaskResponse, completionHandler: @escaping (Data?, URLResponse?, Error?)-> Void) {
        self.testrResponse = response
        self.completionHandler = completionHandler
    }
    
    override func resume() {
        completionHandler(testrResponse.data, testrResponse.urlResponse, testrResponse.error)
    }
    
    override func cancel() {
        
    }
}



