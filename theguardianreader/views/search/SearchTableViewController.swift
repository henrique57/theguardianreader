//
//  PesquisaTableViewController.swift
//  theguardianreader
//
//  Created by Henrique Pereira on 24/09/2018.
//  Copyright © 2018 Henrique Pereira. All rights reserved.
//

import UIKit
import JTMaterialSpinner

class SearchTableViewController: UITableViewController, ModalSectionDelegate {

    @IBOutlet weak var searchBarNoticia: UISearchBar!
    var pesquisa = [Search]()
    var section = ""
    var numberPage : Int = 0
    var isRefreshing : Bool = false
    var selectedSections = [Int : String]()
    var spinnerView = JTMaterialSpinner()

    @IBOutlet weak var buttonFilter: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {    
        super.viewWillAppear(animated)
        
        spinnerView.circleLayer.lineWidth = 3.0
        spinnerView.circleLayer.strokeColor = UIColor.black.cgColor
        spinnerView.animationDuration = 1
        self.view.addSubview(spinnerView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonFilterAction(_ sender: Any) {
        numberPage = 0
        isRefreshing = false
        self.performSegue(withIdentifier: "selectSessionSegue", sender: section)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pesquisa.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? NoticeViewController,
            let sender = sender as? String {
            destinationViewController.selectedData = sender
        }
        
        if let navController = segue.destination as? UINavigationController,
            let destinationViewController = navController.viewControllers.first as? ModalSectionTableViewController {
            destinationViewController.delegate = self
            destinationViewController.selectedSections = self.selectedSections
        }        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "noticeSegue", sender: pesquisa[(indexPath.row)].id)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchTableViewCell
        
        cell.labelNoticia.text = pesquisa[(indexPath.row)].webTitle
        cell.labelDataPublicacao.text = Utils.formatToBrazilianData(data: pesquisa[(indexPath.row)].webPublicationDate)
        cell.labelSessao.text = pesquisa[(indexPath.row)].section
        
        return cell
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) {
            _ in
            self.positionSpinner()
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView){
        if scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height {
            if self.pesquisa.count != 0{
                if  let texto = searchBarNoticia.text{
                    pullRefreshNoticias(section: section, pesquisa: texto)
                }
            }
        }
    }
    
    func beginSpinner (){
        positionSpinner()
        self.spinnerView.isHidden = false
        self.spinnerView.beginRefreshing()
    }
    func stopSpinner () {
        self.spinnerView.isHidden = true
        self.spinnerView.endRefreshing()
    }
    
    func positionSpinner () {
        let contentFrame = UIScreen.main.bounds
        self.spinnerView.frame = CGRect(x: UIDevice.current.orientation.isLandscape ? contentFrame.width/2.15 : contentFrame.width/2.25, y: contentFrame.height/2.75, width: 50, height: 50)
    }
    
    
    func pullRefreshNoticias(section: String, pesquisa: String){
        if !isRefreshing {
            isRefreshing = true
            numberPage += 1
            let query = pesquisa.removeSpecialCharsFromString().replacingOccurrences(of: " ", with: "+")
            let sectionFormatted = section.getPercentString()
            
            let url = LinkManager.getUriSearch(section: sectionFormatted, pageQtt: 15, page: numberPage, resource: "search", query: query)
            self.beginSpinner()
            FetchService.getRequest(url: url,handler: { (items) in
                
                self.pesquisa += ResponseService.mapSearch(json: items)
                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
                self.stopSpinner()
                self.tableView.reloadData()
                self.isRefreshing = false
                
            })
        }
    }
        
    func getSessao(with selectedSections: [Int : String]){
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
        self.section = String(stringSelecionados.dropLast())
        
        return String(stringSelecionados.dropLast())
    }
}

extension SearchTableViewController:  UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBarNoticia.text{
            self.numberPage = 0
            pesquisa.removeAll()
            pullRefreshNoticias(section: section, pesquisa: text)
            
            self.tableView.reloadData()
        }
    }
}
