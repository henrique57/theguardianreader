//
//  ModalSessaoTableViewController.swift
//  theguardianreader
//
//  Created by Henrique Pereira on 25/09/2018.
//  Copyright © 2018 Henrique Pereira. All rights reserved.
//

import UIKit

protocol ModalSessaoDelegate {
    func getSessao(with sessoesSelecionadas: [Int], sessoes: [Sessao])
}

class ModalSessaoTableViewController: UITableViewController {

    var sessao = Sessao(id: "",webTitle: "All", apiUrl: "")
    var sessoes = [Sessao]()
    var sessoesSelecionadas = [Int]()
    var todasSelecionadas: Bool = false
    
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
        delegate?.getSessao(with: self.sessoesSelecionadas, sessoes: self.sessoes)

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
            if sessoesSelecionadas.count == sessoes.count{
                cell.accessoryType = .checkmark
            }
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
                    
                    todasSelecionadas = false
                    
                } else if let selectedIndex = sessoesSelecionadas.index(where: {$0 == dataIndex}) {
                    sessoesSelecionadas.remove(at: selectedIndex)
                    cell.accessoryType = .none
                    
                    if(todasSelecionadas){
                        if let firstCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)){
                            firstCell.accessoryType = .none
                        }
                    }
                    
                }
            } else if cell.accessoryType == .none {
                if(indexPath.row == 0){
                    
                    todasSelecionadas = true
                    
                    let cells = self.tableView.visibleCells
                    cells.forEach{ $0.accessoryType = .checkmark }
                    sessoesSelecionadas.removeAll()
                    for (index, _) in sessoes.enumerated() {
                        sessoesSelecionadas.append(index)
                    }
                } else {
                    if(sessoesSelecionadas.count == (sessoes.count-1)){
                        if let firstCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)){
                            firstCell.accessoryType = .checkmark
                        }
                    }
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
            if let id = sessoes[index].id {
                stringSelecionados.append("\(id)|")
            }
        }
        return String(stringSelecionados.dropLast())
    }
    
    
}
