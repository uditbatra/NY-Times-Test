//
//  ArticleGetAPIMock.swift
//  NY-TimesTests
//
//  Created by Udit Batra on 17/11/18.
//  Copyright © 2018 Udit Batra. All rights reserved.
//

import UIKit
@testable import NY_Times


class ArticleGetAPIMock: ApiGetArticles {
    
    var showSuccessResponse = true

    required init(apiClient: APIClient) {
        
    }
    
    func getArticles(_ parameters: ApiGetArticlesParameters, completionHandler: @escaping ((APIResponse<[Article]>) -> Void)) {
        if(showSuccessResponse){
            completionHandler(APIResponse.success([Article]()))
        }else{
            completionHandler(APIResponse.failure(APIResponseError.networkError))
        }
    }
    

}
