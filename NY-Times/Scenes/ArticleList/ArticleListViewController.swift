//
//  ArticleListViewController.swift
//  NY-Times
//
//  Created by Udit Batra on 17/11/18.
//  Copyright © 2018 Udit Batra. All rights reserved.
//

import UIKit

protocol ArticleListView : class {
    func showLoading()
    func hideLoading()
    
    func refreshArticleList()
    func showErrorMessage(error : String)
    
    func navigateToArticleDetail(articleDetailsInitialiser : ArticleDetailsInitialiser)
}

class ArticleListViewController: UIViewController , ArticleListView{
    var initialiser = ArticleListInitialiserImplementation()
    var viewModel : ArticleListViewModel!
    
    @IBOutlet var tblView : UITableView!
    @IBOutlet var activityIndicator : UIActivityIndicatorView!
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initialiser.initialise(view: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToDetails" {
            let viewController: ArticleDetailsViewController = segue.destination as! ArticleDetailsViewController
            viewController.initialiser = sender as? ArticleDetailsInitialiser
        }
    }
    
    //MARK:- Actions
    @IBAction func btnTryAgainTapped(){
        viewModel.didTapOnTryAgain()
    }
    
    //MARK:- Private
    private func setupTableView(){
        tblView.estimatedRowHeight = 110
        tblView.rowHeight = UITableView.automaticDimension
    }
    
    // MARK: - Protocol functions
    func showLoading(){
        activityIndicator.isHidden = false
        tblView.isHidden = true
    }
    
    func hideLoading(){
        activityIndicator.isHidden = true
    }
    
    func refreshArticleList(){
        activityIndicator.isHidden = true
        tblView.isHidden = false
        tblView.reloadData()
    }
    
    func showErrorMessage(error : String){
        activityIndicator.isHidden = true
        tblView.isHidden = true
        
        let alert = UIAlertController(title: "Alert", message: error, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
            }}))
        self.present(alert, animated: true, completion: nil)
    }
    
    func navigateToArticleDetail(articleDetailsInitialiser: ArticleDetailsInitialiser) {
        self.performSegue(withIdentifier: "ToDetails", sender: articleDetailsInitialiser)
    }
    
    
}


extension ArticleListViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleListCell") as! ArticleListTableViewCellImplementation
        viewModel.configureCell(cellView: cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectIndexpath(indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
