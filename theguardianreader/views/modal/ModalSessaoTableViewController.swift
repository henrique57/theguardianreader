//
//  ModalSessaoTableViewController.swift
//  theguardianreader
//
//  Created by Henrique Pereira on 25/09/2018.
//  Copyright © 2018 Henrique Pereira. All rights reserved.
//

import UIKit

protocol ModalSessaoDelegate {
    func getSessao(with data: String)
}

class ModalSessaoTableViewController: UITableViewController {

    var sessao = Sessao(id: "",webTitle: "All", apiUrl: "")
    var sessoes = [Sessao]()
    var sessoesSelecionadas = [Int]()
    
    var delegate: ModalSessaoDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pullSessoes()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func escolherSessao(_ sender: Any) {
        // -------------------------------------------
        // COLOCAR ARRAY COM TODOS AS SEÇÕES ESCOLHIDAS
        // -------------------------------------------
        //print ("\(sessoes.count) - \(sessoesSelecionadas.count)")

//        if(sessoes.count ==  sessoesSelecionadas.count){
//            sessoesSelecionadas.removeAll()
//        }
        
        delegate?.getSessao(with: prepareData())

        self.dismiss(animated: true)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sessoes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "modalSessaoCelula", for: indexPath) as! ModalSessaoTableViewCell
        // Configure the cell...
        
        switch indexPath.row {
        case 0:
            cell.labelSessao.text = sessao.webTitle
        default:
            cell.labelSessao.text = sessoes[indexPath.row-1].webTitle
            let selectedRow = sessoesSelecionadas.contains(indexPath.row - 1)
            if selectedRow == true {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath){
            let dataIndex = indexPath.row - 1
            
            if cell.accessoryType == .checkmark {
                if(indexPath.row == 0){
                    let cells = self.tableView.visibleCells
                    cells.forEach{ $0.accessoryType = .none }
                    sessoesSelecionadas.removeAll()
                } else if let selectedIndex = sessoesSelecionadas.index(where: {$0 == dataIndex}) {
                    sessoesSelecionadas.remove(at: selectedIndex)
                    cell.accessoryType = .none
                }
            } else if cell.accessoryType == .none {
                if(indexPath.row == 0){
                    let cells = self.tableView.visibleCells
                    cells.forEach{ $0.accessoryType = .checkmark }
                    sessoesSelecionadas.removeAll()
                    for (index, _) in sessoes.enumerated() {
                        sessoesSelecionadas.append(index)
                    }
                } else {
                    sessoesSelecionadas.append(dataIndex)
                    cell.accessoryType = .checkmark
                }
            }
        }
        
    }
    
    func pullSessoes(){
        FetchService.requestSessoes(handler: { (items) in
            if let items = items {
                self.sessoes += items
            }
            self.tableView.reloadData()
        })
    }
    
    func prepareData() -> String{
        var stringSelecionados = ""
        
        sessoesSelecionadas.forEach { index in
            // --------------------
            // ALTERAR CONCATENAÇÃO DO | ou \u{7C}
            // --------------------
            
            if let id = sessoes[index].id {
                stringSelecionados.append("\(id)|")
            }
        }
        let link = String(stringSelecionados.dropLast())
        if let link = link.addingPercentEncoding(withAllowedCharacters: NSMutableCharacterSet.alphanumeric() as CharacterSet){
            return link
        }
        return ""
    }
    
    
}
