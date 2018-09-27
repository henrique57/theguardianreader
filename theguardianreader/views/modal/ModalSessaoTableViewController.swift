//
//  ModalSessaoTableViewController.swift
//  theguardianreader
//
//  Created by Henrique Pereira on 25/09/2018.
//  Copyright © 2018 Henrique Pereira. All rights reserved.
//

import UIKit

protocol ModalSessaoDelegate {
    func getSessao(with selectedSections: [Int : String])
}

class ModalSessaoTableViewController: UITableViewController {

    var sessao = Sessao(id: "",webTitle: "All", apiUrl: "")
    var sessoes = [Sessao]()
    
    //var sessoesSelecionadas = [Int]()
    var selectedSections = [Int : String]()
    
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
        delegate?.getSessao(with: self.selectedSections)
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
            //cell.labelSessao.text = "\(indexPath.row) - \(sessao.webTitle)"
            cell.accessoryType = todasSelecionadas ? .checkmark : .none
        default:
            //cell.labelSessao.text = "\(indexPath.row) - \(sessoes[indexPath.row-1].webTitle)"
            cell.labelSessao.text = sessoes[indexPath.row-1].webTitle
            if selectedSections[indexPath.row - 1] != nil{
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cells = self.tableView.visibleCells
        
        if let cell = tableView.cellForRow(at: indexPath){
            if cell.accessoryType == .checkmark {
                if(indexPath.row == 0){
                    cells.forEach{ $0.accessoryType = .none }
                    selectedSections.removeAll()
                  } else {
                    if(selectedSections.count == sessoes.count){
                        marcaDesmarcaCellAll(cell: cell)
                    }
                    selectedSections.removeValue(forKey: indexPath.row-1)
                    cell.accessoryType = .none
                }
            } else if cell.accessoryType == .none {
                if(indexPath.row == 0){
                    cells.forEach{ $0.accessoryType = .checkmark }
                    selectedSections.removeAll()
                    for (index, value) in sessoes.enumerated() {
                        selectedSections[index] = value.id
                    }
                } else {
                    selectedSections[indexPath.row-1] = sessoes[indexPath.row-1].id
                    cell.accessoryType = .checkmark
                    if(selectedSections.count == sessoes.count){
                        marcaDesmarcaCellAll(cell: cell)
                    }
                }
            }
            todasSelecionadas = selectedSections.count == (sessoes.count) ? true : false
        }
    }
    
    func marcaDesmarcaCellAll(cell: UITableViewCell){
        if let firstCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ModalSessaoTableViewCell {
            firstCell.accessoryType = (firstCell.accessoryType == .checkmark) ? .none : .checkmark
        }
    }
    
    func pullSessoes(){
        FetchService.requestSessoes(handler: { (items) in
            if let items = items {
                self.sessoes += items
            }
            self.todasSelecionadas = self.selectedSections.count == (self.sessoes.count) ? true : false
            self.tableView.reloadData()
        })
    }
    
}
