//
//  ArticleListViewMock.swift
//  NY-TimesTests
//
//  Created by Udit Batra on 17/11/18.
//  Copyright © 2018 Udit Batra. All rights reserved.
//

import UIKit
@testable import NY_Times

class ArticleListViewMock: ArticleListView {
    var refreshListCalled : Bool = false
    var showErrorCalled : Bool = false
    
    func showLoading() {
    }
    
    func hideLoading() {
        
    }
    
    func refreshArticleList() {
        refreshListCalled = true
    }
    
    func showErrorMessage(error: String) {
        showErrorCalled = true
    }
    
    func navigateToArticleDetail(articleDetailsInitialiser: ArticleDetailsInitialiser) {
        
    }
    

}
