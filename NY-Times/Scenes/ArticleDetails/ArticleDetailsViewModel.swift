//
//  ArticleDetailsViewModel.swift
//  NY-Times
//
//  Created by Udit Batra on 17/11/18.
//  Copyright © 2018 Udit Batra. All rights reserved.
//

import UIKit

protocol ArticleDetailsViewModel : class{
    func loadRequest()
    func initialiseView()
}

class ArticleDetailsViewModelImplementation{
    private weak var view : ArticleDetailsView!
    private var article : Article!
    
    init(view : ArticleDetailsView, article : Article) {
        self.view = view
        self.article = article
    }
}

extension ArticleDetailsViewModelImplementation : ArticleDetailsViewModel{
    func initialiseView(){
        loadRequest()
    }
    
    func loadRequest() {
        if(!Reachability.isConnectedToNetwork()){
            view.showErrorMessage("Internet is not available, please connect and try again.")
            return;
        }
        let request = URLRequest(url: article.webPageURL)
        view.loadWebView(request)
    }
}
