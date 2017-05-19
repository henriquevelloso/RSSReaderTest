//
//  DrawerMenuViewController.swift
//  BraviTest
//
//  Created by Henrique Velloso on 18/05/17.
//
//

import UIKit

class DrawerMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Properties
    var feedSources = [String:String]()
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    
    //MARK: - View Delegates
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - Custom Functions
    
    func setupView() {
        
        self.feedSources = RssManager.getFeedSource()
        self.tableView.removeFooterView()
        self.tableView.addDynamicRowHeight(55)
        self.tableView.reloadData()
        self.tableView.isEditing = true
    }
    
    //MARK: - Actions
    
    @IBAction func addSourceAction(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Feed Sources", message: "Adicione o Nome e URL de um feed.", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Adicionar", style: .default) { (_) in
            
            var nome : String?
            var url : String?
            
            if let field = alertController.textFields?[0] {
                nome = field.text
            }
            
            if let field = alertController.textFields?[1] {
                url = field.text
            }
            
            if nome != "" && url != "" {
                
                RssManager.loadItemsFromUrl(url: url!).then { items -> Void in
                    
                    RssManager.insertFeedSource(name: nome!, url: url!)
                    self.feedSources = RssManager.getFeedSource()
                    self.tableView.reloadData()
                    
                    }.catch { _ in
                        
                        let alert = UIAlertController(title: "Atenção", message: "Verifique o URL de seu feed e tente novamente", preferredStyle: UIAlertControllerStyle.alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { _ in
                            self.addSourceAction(self.addButton)
                        }))
                        self.present(alert, animated: true, completion: nil)
                        
                }
                
                
                
                
            } else {
                
                let alert = UIAlertController(title: "Atenção", message: "Você deve preencher com NOME e URL para poder adicionar um novo feed.", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { _ in
                    self.addSourceAction(self.addButton)
                }))
                self.present(alert, animated: true, completion: nil)
                
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Nome"
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Url"
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - TableView Delegates
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.feedSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedSource", for: indexPath) as! DrawerMenuTableViewCell
        
        for (index,source) in self.feedSources.enumerated() {
            if index == indexPath.row {
                
                cell.nome.text = source.key
                cell.url.text = source.value
                
            }
        }
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Remover") { (action, IndexPath) in
            
            for (index,source) in self.feedSources.enumerated() {
                if index == indexPath.row {
                    
                    RssManager.removeFeedSource(name: source.key)
                    self.feedSources = RssManager.getFeedSource()
                    self.tableView.deleteRows(at: [IndexPath as IndexPath], with: .fade)
                    
                    break
                }
            }
            
        }
        
        return [deleteAction]
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
