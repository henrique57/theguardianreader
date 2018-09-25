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
    var section = ""
    var numberPage : Int = 0
    var isRefreshing : Bool = false

    @IBOutlet weak var buttonFilter: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if let webTitle = section.webTitle{
//            buttonFilter.setTitle("Filter: \(webTitle)", for: .normal)
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func buttonFilterAction(_ sender: Any) {
        // ----------- ACTION BUTTON FILTER -------
        numberPage = 0
        isRefreshing = false
        self.performSegue(withIdentifier: "selecionaSessaoTv", sender: "")
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
        
        if let navController = segue.destination as? UINavigationController,
            let destinationViewController = navController.viewControllers.first as? ModalSessaoTableViewController {
            destinationViewController.delegate = self
        }        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "listaNoticiaPesquisada", sender: pesquisa[(indexPath.row)].id)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCell(withIdentifier: "pesquisaCelula", for: indexPath) as! PesquisaTableViewCell
        
        cell.labelNoticia.text = pesquisa[(indexPath.row)].webTitle
        cell.labelDataPublicacao.text = ApiService.formataData(data: pesquisa[(indexPath.row)].webPublicationDate)
        cell.labelSessao.text = pesquisa[(indexPath.row)].section
        
        return cell
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView){
        if scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height {
            if  let texto = searchBarNoticia.text{
                pullRefreshNoticias(section: section, pesquisa: texto)
            }
        }
    }
    
    func pullRefreshNoticias(section: String, pesquisa: String){
        if !isRefreshing {
            isRefreshing = true
            numberPage += 1
           
            let query = pesquisa.replacingOccurrences(of: " ", with: "+")
            FetchService.requestPesquisa(section: section,page: numberPage, query: query ,handler: { (items) in
                if let items = items {
                    self.pesquisa += items
                }
                self.tableView.reloadData()
                self.isRefreshing = false
            })
        }
    }
        
    func getSessao(with data: String){
        // -------------------------------------------
        // PESQUISAR PELAS SECTIONS DESCRITAS
        // -------------------------------------------
        
        if let pesquisa = searchBarNoticia.text  {
            //self.section = data
            self.pesquisa.removeAll()
            print(data)
            pullRefreshNoticias(section: data, pesquisa: pesquisa)
        }
    }

}

extension PesquisaTableViewController:  UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // ------------------------
        // COLOCAR AÇÃO DA PESQUISA
        // ------------------------
        if let text = searchBarNoticia.text{
            pullRefreshNoticias(section: section, pesquisa: text)
        }
    }
}
