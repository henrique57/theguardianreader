//
//  SessaoTableViewController.swift
//  theguardianreader
//
//  Created by Henrique Pereira on 18/09/2018.
//  Copyright © 2018 Henrique Pereira. All rights reserved.
//

import UIKit
import SwiftyJSON

class SectionTableViewController: UITableViewController {

    var sections = [Section]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pullSessoes()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? NoticeSectionTableViewController,
            let sender = sender as? Section {
                destinationViewController.selectedData = sender.id
                destinationViewController.titulo = sender.webTitle
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "noticeSectionSegue", sender: sections[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sectionCell", for: indexPath) as! SectionTableViewCell
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        cell.labelTitle.text = sections[indexPath.row].webTitle
        return cell
    }
    
    func pullSessoes(){
        let url = LinkManager.getUriSections(recurso: "sections")
        FetchService.getRequest(url: url) { (items) in
            self.sections = ResponseService.mapSections(json: items)
            self.tableView.reloadData()
        }
    }
}
