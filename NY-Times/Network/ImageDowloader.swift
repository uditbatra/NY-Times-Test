//
//  ImageDowloader.swift
//  NY-Times
//
//  Created by Udit Batra on 17/11/18.
//  Copyright © 2018 Udit Batra. All rights reserved.
//

import UIKit

protocol ImageDownloaderDelegate : class{
    func didDownloadImage(image : UIImage, url : URL)
}

protocol ImageDownloader {
    var delegate: ImageDownloaderDelegate! {set get}
    func downloadImageWithURL(_ url : URL)
}

class ImageDownloaderImplementation : NSObject, ImageDownloader{
    weak var delegate: ImageDownloaderDelegate!
    private var session : URLSession!
    
    override init() {
        super.init()
        session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
    }
    
    func downloadImageWithURL(_ url : URL){
        session.dataTask(with: url) { [weak self](data, response, error) in
            if (data != nil){
                guard let image = UIImage(data: data!) else {
                    return
                }
                self?.delegate.didDownloadImage(image: image, url: url)
            }
            }.resume()
    }
}

extension ImageDownloaderImplementation : URLSessionDownloadDelegate{
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        guard let image = UIImage(contentsOfFile: location.path) else {
            return
        }
        delegate.didDownloadImage(image: image, url: downloadTask.originalRequest!.url!)
    }
}



