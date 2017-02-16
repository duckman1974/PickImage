//
//  DetailViewController.swift
//  PickImage
//
//  Created by Candice Reese on 2/12/17.
//  Copyright © 2017 Kevin Reese. All rights reserved.
//

//import Foundation
import UIKit

class DetailViewController: UIViewController {
    
    
    @IBOutlet weak var memeImg: UIImageView!
    
    var meme: UIImage!
    
    
    
    override var prefersStatusBarHidden: Bool{
        
        return true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memeImg.image = meme
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    
    
    
    
}
