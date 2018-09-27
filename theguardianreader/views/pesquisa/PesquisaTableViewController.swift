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
    
    var selectedSections = [Int : String]()
    
    //var sessoes = [Sessao]()
    //var sessoesSelecionadas = [Int]()

    @IBOutlet weak var buttonFilter: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //pullRefreshNoticias(section: section, pesquisa: "")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func buttonFilterAction(_ sender: Any) {
        // ----------- ACTION BUTTON FILTER -------
        numberPage = 0
        isRefreshing = false
        self.performSegue(withIdentifier: "selecionaSessaoTv", sender: section)
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
            destinationViewController.selectedSections = self.selectedSections
        }        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "listaNoticiaPesquisada", sender: pesquisa[(indexPath.row)].id)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCell(withIdentifier: "pesquisaCelula", for: indexPath) as! PesquisaTableViewCell
        
        cell.labelNoticia.text = pesquisa[(indexPath.row)].webTitle
        cell.labelDataPublicacao.text = pesquisa[(indexPath.row)].webPublicationDate?.formatData()
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
            
           //----
            let query = pesquisa.replacingOccurrences(of: " ", with: "+")
            //----
            
            FetchService.requestPesquisa(section: section,page: numberPage, query: query ,handler: { (items) in
                if let items = items {
                    self.pesquisa += items
                }
                self.tableView.reloadData()
                self.isRefreshing = false
            })
        }
    }
        
    func getSessao(with selectedSections: [Int : String]){
        // -------------------------------------------
        // PESQUISAR PELAS SECTIONS DESCRITAS
        // -------------------------------------------
        
        if let pesquisa = searchBarNoticia.text  {
            self.selectedSections = selectedSections
            self.pesquisa.removeAll()
            
            pullRefreshNoticias(section: prepareData(), pesquisa: pesquisa)
        }
    }
    
    func prepareData() -> String{
        var stringSelecionados = ""
        
        [String](selectedSections.values).forEach { (id) in
            stringSelecionados.append("\(id)|")
        }
        
        // Save sections to do the refresh later
        self.section = String(stringSelecionados.dropLast())
        
        return String(stringSelecionados.dropLast())
    }

}

extension PesquisaTableViewController:  UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // ------------------------
        // COLOCAR AÇÃO DA PESQUISA
        // ------------------------
        if let text = searchBarNoticia.text{
            self.numberPage = 0
            pesquisa.removeAll()
            pullRefreshNoticias(section: section, pesquisa: text)
            
            self.tableView.reloadData()
        }
    }
}
