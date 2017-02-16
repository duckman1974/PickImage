//
//  SentMemeTableViewController.swift
//  PickImage
//
//  Created by Candice Reese on 2/10/17.
//  Copyright © 2017 Kevin Reese. All rights reserved.
//

import Foundation
import UIKit

class SentMemeTableViewController: UITableViewController{
    
    
    @IBOutlet var sentMemeTableView: UITableView!
    
    
    var memes: [Meme]{
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        sentMemeTableView.reloadData()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sentMemeTableView.reloadData()
        
    }
   
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return memes.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SentMemeTableViewCell")!
        let meme = self.memes[(indexPath as NSIndexPath).row]
        cell.imageView?.image = meme.memedImage
        cell.textLabel?.text = meme.topText + "...." + meme.bottomText
        
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailController = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailController.meme = memes[indexPath.row].memedImage
        self.navigationController?.pushViewController(detailController, animated: true)
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
   //function below allows user to delete rows in tableview
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
            
        if (editingStyle == UITableViewCellEditingStyle.delete) {
    
            let object = UIApplication.shared.delegate
            let appDelegate = object as! AppDelegate
            appDelegate.memes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
            sentMemeTableView.reloadData()
            
        }
    
    }
    
    
}
