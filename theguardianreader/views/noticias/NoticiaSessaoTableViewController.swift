//
//  NoticiasSessaoTableViewController.swift
//  theguardianreader
//
//  Created by Henrique Pereira on 19/09/2018.
//  Copyright © 2018 Henrique Pereira. All rights reserved.
//

import UIKit

class NoticiaSessaoTableViewController: UITableViewController {

    var selectedData: String?
    var isRefreshing : Bool = false
    var links = [NoticiaSessao]()
 
    override func viewWillAppear(_ animated: Bool) {
        self.title = selectedData
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //generateExample()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return links.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noticiaCelula", for: indexPath) as! NoticiaSessaoTableViewCell

        // Configure the cell...
        cell.labelNoticia.text = links[indexPath.row].webPublicationDate
        
        return cell
    }
    
    func pullRefreshSessoes(){
        if !isRefreshing {
            isRefreshing = true
            FetchService.requestSessoes(handler: { (items) in
                if let items = items {
                    self.sessoes += items
                }
                self.tableView.reloadData()
                self.isRefreshing = false
            })
        }
    }
    
}
