//
//  ArticleListInitialiser.swift
//  NY-Times
//
//  Created by Udit Batra on 17/11/18.
//  Copyright © 2018 Udit Batra. All rights reserved.
//

import UIKit

protocol ArticleListInitialiser : class{
    func initialise(view : ArticleListViewController)
}

class ArticleListInitialiserImplementation : ArticleListInitialiser{
    
    func initialise(view : ArticleListViewController){
        
        let apiClient = APIClientImplementation(urlSession: URLSession.shared)
        let api = ApiGetArticlesImplementation(apiClient: apiClient)
        
        let modelView = ArticleListViewModelImplementation.init(view: view, getAPI: api)
        view.viewModel = modelView
    }
}
