//
//  SessaoTableViewController.swift
//  theguardianreader
//
//  Created by Henrique Pereira on 18/09/2018.
//  Copyright © 2018 Henrique Pereira. All rights reserved.
//

import UIKit

class SessaoTableViewController: UITableViewController {

    var sessoes = [Sessao]()
    var isRefreshing : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pullRefreshSessoes()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sessoes.count
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? NoticiaSessaoTableViewController,
            let sender = sender as? String {
            destinationViewController.selectedData = sender
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "listaNoticiasSessao", sender: sessoes[indexPath.row].apiUrl)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sessaoCelula", for: indexPath) as! SessaoTableViewCell
        //let sessao = sessoes[indexPath.row]
        //cell.labelTitle.text = sessao.webTitle
    
        cell.labelTitle.text = sessoes[indexPath.row].webTitle
        return cell
    }
    
    func pullRefreshSessoes(){
        if !isRefreshing {
            isRefreshing = true
            FetchService.requestSessoes(handler: { (items) in
                self.tableView.reloadData()
                self.isRefreshing = false
            })
        }
    }
}
