//
//  ArticleDetailsInitialiser.swift
//  NY-Times
//
//  Created by Udit Batra on 17/11/18.
//  Copyright © 2018 Udit Batra. All rights reserved.
//

import UIKit

protocol ArticleDetailsInitialiser : class{
    func initilaise(view : ArticleDetailsViewController)
}

class ArticleDetailsInitialiserImplementation : ArticleDetailsInitialiser{
    
    private var article : Article!
    
    init(article : Article) {
        self.article = article
    }
    
    func initilaise(view : ArticleDetailsViewController){
        let viewModel = ArticleDetailsViewModelImplementation(view: view, article: article)
        view.viewModel = viewModel
    }
}
