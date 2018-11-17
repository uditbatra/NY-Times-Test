//
//  ApiClient.swift
//  NY-Times
//
//  Created by Udit Batra on 17/11/18.
//  Copyright © 2018 Udit Batra. All rights reserved.
//

import UIKit

import Foundation

protocol APIRequest{
    var urlRequest : URLRequest {get}
}

protocol APIClient : class {
    func executeRequest<T, P : APIParser>(apiRequest: APIRequest, parser : P, completionHandler: @escaping ((_ apiResponse : APIResponse<T>) -> Void))
    func cancelRequest()
}

protocol URLSessionDataTaskProtocol {
    func resume()
    func cancel()
}

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTask
}

extension URLSession : URLSessionProtocol{}
extension URLSessionDataTask : URLSessionDataTaskProtocol{}

enum APIResponse<T>{
    case success(T)
    case failure(Error)
}

enum APIResponseError : Error, LocalizedError{
    case networkError
    case parsingError
    
    public var errorDescription: String? {
        switch self {
        case .networkError, .parsingError:
            return "We could not complete your request, please try again."
        }
    }
}

protocol APIParser{
    associatedtype T
    func parseData(_ data : Data) throws -> T
}

class APIClientImplementation: APIClient {
    
    private var urlSession : URLSessionProtocol!
    private var urlSessionDataTask : URLSessionDataTaskProtocol?
    
    init(urlSession : URLSessionProtocol) {
        self.urlSession = urlSession
    }
    
    func executeRequest<T, P : APIParser>(apiRequest: APIRequest, parser : P, completionHandler: @escaping ((_ apiResponse : APIResponse<T>) -> Void)) {
        
        urlSessionDataTask = urlSession.dataTask(with: apiRequest.urlRequest) {[weak self] (data, urlResponse, error) in
            guard let httpResponse = urlResponse as? HTTPURLResponse else{
                self?.clearDataTask()
                return completionHandler(APIResponse.failure(error ?? APIResponseError.networkError))
            }
            
            if(httpResponse.statusCode == 200){
                if data != nil{
                    do{
                        guard let parsedData = try parser.parseData(data!) as? T else{
                            completionHandler(APIResponse.failure(APIResponseError.parsingError))
                            return
                        }
                        
                        self?.clearDataTask()
                        completionHandler(APIResponse.success(parsedData))
                    }catch{
                        self?.clearDataTask()
                        completionHandler(APIResponse.failure(error))
                    }
                }
            }else{
                self?.clearDataTask()
                completionHandler(APIResponse.failure(error ?? APIResponseError.networkError))
            }
        }
        urlSessionDataTask!.resume()
    }
    
    func cancelRequest() {
        if(urlSessionDataTask != nil){
            urlSessionDataTask?.cancel()
            clearDataTask()
        }
    }
    
    private func clearDataTask(){
        urlSessionDataTask = nil
    }
}

