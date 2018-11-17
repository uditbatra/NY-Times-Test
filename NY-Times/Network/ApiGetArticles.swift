//
//  ApiGetArticles.swift
//  NY-Times
//
//  Created by Udit Batra on 17/11/18.
//  Copyright © 2018 Udit Batra. All rights reserved.
//

import UIKit

struct ApiGetArticlesParameters{
    let days : String
}

protocol ApiGetArticles : class{
    init(apiClient : APIClient)
    func getArticles(_ parameters : ApiGetArticlesParameters, completionHandler: @escaping ((_ arrArticles : APIResponse<[Article]>) -> Void))
}

//MARK:-
struct ArticleFetchAPIRequest : APIRequest{
    
    private var url : URL!
    
    init(_ parameters : ApiGetArticlesParameters) {
        let urlString = "https://api.nytimes.com/svc/mostpopular/v2/mostviewed/all-sections/\(parameters.days).json?api-key=7f0e0aa6182c432ea089404df484c206"
        url = URL(string: urlString)
    }
    
    var urlRequest: URLRequest{
        return URLRequest(url: url)
    }
}

//MARK:-
struct ArticleFetchAPIParser : APIParser {
    func parseData(_ data : Data) throws -> [Article]{
        guard let responseDict = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String : Any] else{
            throw APIResponseError.parsingError
        }
        guard let status = responseDict["status"] as? String, let arrResults = responseDict["results"] as? [[String : Any]] else{
            throw APIResponseError.parsingError
        }
        if status == "OK"{
            let arrArticles = arrResults.compactMap(Article.init)
            return arrArticles
        }else{
            throw APIResponseError.parsingError
        }
    }
}

//MARK:-
class ApiGetArticlesImplementation : NSObject , ApiGetArticles{
    
    private var apiClient : APIClient!
    private var completionHandler : ((_ arrArticles : APIResponse<[Article]>) -> Void)!
    
    required init(apiClient : APIClient){
        self.apiClient = apiClient
    }
    
    // This is only for Objective-C as APIClient class is not supported in it because of using generics.
    override init() {
        self.apiClient = APIClientImplementation(urlSession: URLSession.shared)
    }
    
    func getArticles(_ parameters: ApiGetArticlesParameters, completionHandler: @escaping ((APIResponse<[Article]>) -> Void)) {

        self.completionHandler = completionHandler
        
        let apiRequest = ArticleFetchAPIRequest(parameters)
        let apiParser = ArticleFetchAPIParser()
        
        apiClient.executeRequest(apiRequest: apiRequest, parser: apiParser) { [weak self](apiResponse : APIResponse<[Article]>) in
            self?.completionHandler(apiResponse)
        }
    }
}
