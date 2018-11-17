//
//  ArticleListViewModel.swift
//  NY-Times
//
//  Created by Udit Batra on 17/11/18.
//  Copyright © 2018 Udit Batra. All rights reserved.
//

import UIKit

protocol ArticleListViewModel : class{
    func numberOfRows() -> Int
    func configureCell(cellView : ArticleListTableViewCell, indexPath : IndexPath)
    func didTapOnTryAgain()
    func didSelectIndexpath(_ indexPath : IndexPath)
}

class ArticleListViewModelImplementation: ArticleListViewModel {
    private var arrArticles = [Article]()
    private weak var view : ArticleListView!
    private var getAPI : ApiGetArticles!
    
    private var imageDownloadManager :ImageDownloader!
    
    init(view: ArticleListView, getAPI: ApiGetArticles) {
        self.view = view
        self.getAPI = getAPI
        self.imageDownloadManager = ImageDownloaderImplementation()
        self.imageDownloadManager.delegate = self
        
        getArticles()
    }
    
    func numberOfRows() -> Int {
        return arrArticles.count
    }
    
    func configureCell(cellView : ArticleListTableViewCell, indexPath : IndexPath){
        cellView.indexPath = indexPath
        
        let article = arrArticles[indexPath.row]
        cellView.displayTitle(article.title)
        cellView.displayDate(article.date)
        cellView.displayPublishedBy(article.publishedBy)
        
        if(article.thumbnailURL != nil){
            if(article.thumbnail != nil){
                cellView.displayImage(article.thumbnail!)
            }else{
                imageDownloadManager.downloadImageWithURL(article.thumbnailURL!)
            }
        }
    }
    
    func didTapOnTryAgain(){
        getArticles()
    }
    
    func didSelectIndexpath(_ indexPath : IndexPath){
        let article = arrArticles[indexPath.row]
        view.navigateToArticleDetail(articleDetailsInitialiser: ArticleDetailsInitialiserImplementation(article: article))
    }
    
    //MARK: API calling
    private func getArticles(){
        view.showLoading()
        let param = ApiGetArticlesParameters(days: "7")
        getAPI.getArticles(param) {[weak self] (apiResponse : APIResponse<[Article]>) in
            switch apiResponse{
            case .success(let arrArticles):
                self!.handleSuccess(arrArticles: arrArticles)
                
            case .failure(let error):
                self!.handleFailure(error: error.localizedDescription)
            }
        }
    }
    
    private func handleSuccess(arrArticles : [Article]){
        DispatchQueue.main.async {[weak self] in
            self?.arrArticles = arrArticles
            self?.view.refreshArticleList()
        }
    }
    
    private func handleFailure(error : String){
        DispatchQueue.main.async {[weak self] in
            self?.view.showErrorMessage(error: error)
        }
    }
}


extension ArticleListViewModelImplementation : ImageDownloaderDelegate{
    func didDownloadImage(image : UIImage, url : URL){
        DispatchQueue.main.async {[weak self] in
            let arr = self?.arrArticles.filter { (article) -> Bool in
                return article.thumbnailURL == url
            }
            
            if(arr!.count != 0){
                let article = arr![0]
                article.thumbnail = image
                self?.view.refreshArticleList()
            }
        }
    }
}
