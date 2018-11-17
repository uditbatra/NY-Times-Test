//
//  ArticleListTableViewCell.swift
//  NY-Times
//
//  Created by Udit Batra on 17/11/18.
//  Copyright © 2018 Udit Batra. All rights reserved.
//

import UIKit

protocol ArticleListTableViewCell : class{
    var indexPath : IndexPath!{set get}
    
    func displayTitle(_ title : String)
    func displayPublishedBy(_ publishedBy : String)
    func displayDate(_ date : String)
    func displayImage(_ img : UIImage)
}

class ArticleListTableViewCellImplementation: UITableViewCell,ArticleListTableViewCell {
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var lblPublishedBy : UILabel!
    @IBOutlet weak var lblDate : UILabel!
    @IBOutlet weak var imgThumbnail : UIImageView!
    var indexPath : IndexPath!
    
    func displayTitle(_ title : String){
        lblTitle.text = title
    }
    
    func displayPublishedBy(_ publishedBy : String){
        lblPublishedBy.text = publishedBy
    }
    
    func displayDate(_ date : String){
        lblDate.text = date
    }
    
    func displayImage(_ img : UIImage){
        imgThumbnail.image = img
    }
}
