//
//  ArticleDetailsViewController.swift
//  NY-Times
//
//  Created by Udit Batra on 17/11/18.
//  Copyright © 2018 Udit Batra. All rights reserved.
//

import UIKit

import WebKit

protocol ArticleDetailsView : class{
    func showLoading()
    func showErrorMessage(_ error : String)
    func loadWebView(_ urlRequest : URLRequest)
}

class ArticleDetailsViewController: UIViewController, ArticleDetailsView {
    
    @IBOutlet weak var webView : WKWebView!
    @IBOutlet weak var activity : UIActivityIndicatorView!
    
    var initialiser : ArticleDetailsInitialiser!
    var viewModel : ArticleDetailsViewModel!
    
    //MARK:- Actions
    override func viewDidLoad() {
        super.viewDidLoad()
        initialiser.initilaise(view: self)
        viewModel.initialiseView()
        webView.navigationDelegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        webView.stopLoading()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Actions
    @IBAction func btnTryAgainTapped(){
        viewModel.loadRequest()
    }
    
    //MARK:- Protocol function
    
    func showLoading(){
        activity.isHidden = false
        webView.isHidden = false
    }
    
    func showWebView(){
        activity.isHidden = true
        webView.isHidden = false
    }
    
    func showErrorMessage(_ error : String){
        activity.isHidden = true
        webView.isHidden = true
        
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
    
    func loadWebView(_ urlRequest : URLRequest){
        webView.load(urlRequest)
    }
}


extension ArticleDetailsViewController : WKNavigationDelegate{
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!){
        showLoading()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        showWebView()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error){
        showErrorMessage("Please try again later")
    }
}
