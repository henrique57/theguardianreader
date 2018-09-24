//
//  PesquisaTableViewController.swift
//  theguardianreader
//
//  Created by Henrique Pereira on 24/09/2018.
//  Copyright © 2018 Henrique Pereira. All rights reserved.
//

import UIKit

class PesquisaTableViewController: UITableViewController, ModalSessaoDelegate {

    @IBOutlet weak var searchBarNoticia: UISearchBar!
    var pesquisa = [Pesquisa]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pesquisa.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? NoticiaViewController,
            let sender = sender as? String {
            destinationViewController.selectedData = sender
        }
        
        if let destinationViewController = segue.destination as? ModalSessaoViewController {
            destinationViewController.delegate = self
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "listaNoticiaPesquisada", sender: pesquisa[indexPath.row].id)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "pesquisaCelula", for: indexPath) as! PesquisaTableViewCell
        
        cell.labelNoticia.text = pesquisa[indexPath.row].webTitle
        cell.labelDataPublicacao.text = ApiService.formataData(data: pesquisa[indexPath.row].webPublicationDate)
        cell.labelSessao.text = pesquisa[indexPath.row].section
        
        return cell
    }
    
    func pullRefreshNoticias(section: String, pesquisa: String){
        self.pesquisa.removeAll()
        FetchService.requestPesquisa(section: section, query: pesquisa ,handler: { (items) in
            if let items = items {
                self.pesquisa += items
            }
            self.tableView.reloadData()
            
        })
    }
    
    
    func getSessao(with data: Sessao){
        //print(data.id)
        
        if let pesquisa = searchBarNoticia.text {
            if let section = data.id {
                pullRefreshNoticias(section: section, pesquisa: pesquisa)
            }
        }
    }
    
}

extension PesquisaTableViewController:  UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.performSegue(withIdentifier: "modalPickerSessao", sender: "")
    }
}
