//
//  RSSDetailViewController.swift
//  BraviTest
//
//  Created by Henrique Velloso on 18/05/17.
//
//

import UIKit
import AlamofireRSSParser
import SafariServices


class RSSDetailViewController: UIViewController, SFSafariViewControllerDelegate {
    
    //MARK: - Outlets
    @IBOutlet weak var data: UILabel!
    @IBOutlet weak var source: UILabel!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var descricao: UILabel!
    @IBOutlet weak var imageDefaut: UIImageView!
    
    
    //MARK: - Properties
    var selectedFeedItem : RSSItem?
    
    //MARK: - View Delegates
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Actions
    
    @IBAction func lerVersaoCompletaAction(_ sender: UIButton) {
        
        let url = URL(string: selectedFeedItem!.link!)
        let safariVC = SFSafariViewController(url: url!, entersReaderIfAvailable: false)
        safariVC.delegate = self
        self.present(safariVC, animated: true, completion: nil)
        
    }
    
    
    //MARK: - Custom Functions
    
    func setupView() {
        
        self.data.text = self.selectedFeedItem!.pubDate!.formatToString()
        self.source.text = self.selectedFeedItem!.source!
        self.titulo.text = self.selectedFeedItem!.title!
        self.descricao.text = self.selectedFeedItem!.itemDescription?.removeHtmlTags()
        
        if let urlString = self.selectedFeedItem!.imagesFromDescription?.first {
            
            let url = URL(string: urlString)
            self.imageDefaut.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "loading"), options: nil, progressBlock: nil, completionHandler: nil)
            
        } else {
            self.imageDefaut.image = #imageLiteral(resourceName: "noimage")
            
        }
        
        
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
