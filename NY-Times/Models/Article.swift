//
//  Article.swift
//  NY-Times
//
//  Created by Udit Batra on 17/11/18.
//  Copyright © 2018 Udit Batra. All rights reserved.
//

import Foundation
import UIKit

class Article{
    var title : String
    var publishedBy : String
    var webPageURL : URL
    var date : String
    var thumbnail : UIImage?
    var thumbnailURL : URL?
    
    init?(dic : [String : Any]) {
        guard
            let title = dic["title"] as? String,
            let publishedBy = dic["byline"] as? String,
            let webPageURLStr = dic["url"] as? String,
            let webPageURL = URL(string: webPageURLStr),
            let date = dic["published_date"] as? String
            else{
                return nil
        }
        
        self.title = title
        self.publishedBy = publishedBy
        self.webPageURL = webPageURL
        self.date = date
        
        if let arrMedia = dic["media"] as? [[String : Any]]{
            if(arrMedia.count == 0){
                return nil
            }
            
            let dicMedia = arrMedia[0]
            guard let arrMediaMetaData = dicMedia["media-metadata"] as? [[String : Any]] else{
                return
            }
            
            let arrThumbnail = arrMediaMetaData.filter { (dic) -> Bool in
                return dic["format"] as? String == "Standard Thumbnail"
            }
            
            if(arrThumbnail.count != 0){
                let dic = arrThumbnail[0]
                if let urlStr = dic["url"] as? String,
                    let url = URL(string: urlStr)
                {
                    self.thumbnailURL = url
                }
            }
        }
        
    }
    
}

