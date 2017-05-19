//
//  FeedViewController.swift
//  BraviTest
//
//  Created by Henrique Velloso on 18/05/17.
//
//

import UIKit
import PromiseKit
import AlamofireRSSParser
import Kingfisher

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    //MARK: - Properties
    lazy var feedItems = [RSSItem]()
    var refreshControl = UIRefreshControl()
    var selectedFeedItem : RSSItem?
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - View Delegates
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.loadFeedItems()
        
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Custom Functions
    
    func setupView() {
        
        self.tableView.addDynamicRowHeight(250)
        self.tableView.removeFooterView()
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Puxe para atualizar")
        refreshControl.addTarget(self, action: #selector(self.loadFeedItems), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
        
        UIApplication.shared.statusBarStyle = .lightContent
        self.addMenuButton()
        
    }
    
    func loadFeedItems() {
        
        refreshControl.attributedTitle = NSAttributedString(string: "Atualizando...")
        
        RssManager.loadItemsFromAllFeedSource().then { feedItemsResult in
            self.feedItems = feedItemsResult
            }.always {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                self.refreshControl.attributedTitle = NSAttributedString(string: "Puxe para atualizar")
        }
        
    }
    
    func defaultMenuImage() -> UIImage {
        var defaultMenuImage = UIImage()
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 30, height: 22), false, 0.0)
        
        UIColor.black.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 3, width: 25, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 10, width: 25, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 17, width: 25, height: 1)).fill()
        
        UIColor.white.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 4, width: 25, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 11,  width: 25, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 18, width: 25, height: 1)).fill()
        
        defaultMenuImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return defaultMenuImage;
    }
    
    func addMenuButton(){
        let btnShowMenu = UIButton(type: UIButtonType.system)
        btnShowMenu.setImage(self.defaultMenuImage(), for: UIControlState())
        btnShowMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnShowMenu.addTarget(self, action: #selector(self.onMenuButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        let customBarItem = UIBarButtonItem(customView: btnShowMenu)
        self.navigationItem.leftBarButtonItem = customBarItem;
    }
    
    func onMenuButtonPressed(_ sender : UIButton){
        performSegue(withIdentifier: "menuSegue", sender: nil)
    }
    
    //MARK: - TableView Delegates and Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.feedItems.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedItem", for: indexPath) as! FeedItemTableViewCell
        let feedItem = self.feedItems[indexPath.row]
        
        cell.data.text = feedItem.pubDate!.formatToString()
        cell.source.text = feedItem.source!
        cell.titulo.text = feedItem.title!
        if let urlString = feedItem.imagesFromDescription?.first {
            
            let url = URL(string: urlString)
            cell.imageDefaut.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "loading"), options: nil, progressBlock: nil, completionHandler: nil)
            
        } else {
            cell.imageDefaut.image = #imageLiteral(resourceName: "noimage")
            
        }
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedFeedItem = self.feedItems[indexPath.row]
        performSegue(withIdentifier: "rssDetailSegue", sender: nil)
        
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "rssDetailSegue" {
            
            let destinationViewController = segue.destination as! RSSDetailViewController
            destinationViewController.selectedFeedItem = self.selectedFeedItem
            destinationViewController.title = self.selectedFeedItem?.source
        }
        
    }
    
    
}
