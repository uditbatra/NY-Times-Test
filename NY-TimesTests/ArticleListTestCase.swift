//
//  ArticleListTestCase.swift
//  NY-TimesTests
//
//  Created by Udit Batra on 17/11/18.
//  Copyright © 2018 Udit Batra. All rights reserved.
//

import UIKit
import XCTest
@testable import NY_Times

class ArticleListTestCase: XCTestCase {
    var api : ArticleGetAPIMock!
    var view = ArticleListViewMock()
    var viewModel : ArticleListViewModel!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let apiClient = APIClientImplementation(urlSession: URLSessionStub())
        api = ArticleGetAPIMock(apiClient: apiClient)
        
    }
    
    func test_articles_load_success(){
        api.showSuccessResponse = true
        viewModel = ArticleListViewModelImplementation(view: view, getAPI: api)
        
        let expect = expectation(description: "Expectation")
        DispatchQueue.main.async {[weak self] in
            XCTAssert(self!.view.refreshListCalled, "Refresh list method did not call")
            
            expect.fulfill()
        }
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func test_articles_load_failure(){
        api.showSuccessResponse = false
        viewModel = ArticleListViewModelImplementation(view: view, getAPI: api)
        
        let expect = expectation(description: "Expectation")
        DispatchQueue.main.async {[weak self] in
            XCTAssert(self!.view.showErrorCalled, "Show error method did not call")
            
            expect.fulfill()
        }
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
