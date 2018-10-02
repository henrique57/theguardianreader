//
//  ModalSessaoTableViewController.swift
//  theguardianreader
//
//  Created by Henrique Pereira on 25/09/2018.
//  Copyright © 2018 Henrique Pereira. All rights reserved.
//

import UIKit

// MARK: - Protocol
protocol ModalSectionDelegate {
    func getSessao(with selectedSections: [Int : String])
}

class ModalSectionTableViewController: UITableViewController {

    var section = Section(id: "",webTitle: "All", apiUrl: "")
    var sections = [Section]()
    var selectedSections = [Int : String]()
    var todasSelecionadas: Bool = false
    var delegate: ModalSectionDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pullSections()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Return the number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // MARK: - Return the number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "modalSessaoCelula", for: indexPath) as! ModalSectionTableViewCell
        
        // Configure the cell...
        switch indexPath.row {
        case 0:
            cell.labelSessao.text = section.webTitle
            cell.accessoryType = (todasSelecionadas) ? .checkmark : .none
        default:
            cell.labelSessao.text = sections[indexPath.row-1].webTitle
            cell.accessoryType = (selectedSections[indexPath.row - 1] != nil) ? .checkmark : .none
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
                    if(selectedSections.count == sections.count){ checkUncheckFirstCell() }
                    selectedSections.removeValue(forKey: indexPath.row-1)
                    cell.accessoryType = .none
                }
            } else if cell.accessoryType == .none {
                if(indexPath.row == 0){
                    cells.forEach{ $0.accessoryType = .checkmark }
                    selectedSections.removeAll()
                    for (index, value) in sections.enumerated() {
                        selectedSections[index] = value.id
                    }
                } else {
                    selectedSections[indexPath.row-1] = sections[indexPath.row-1].id
                    cell.accessoryType = .checkmark
                    if(selectedSections.count == sections.count){ checkUncheckFirstCell() }
                }
            }
            todasSelecionadas = selectedSections.count == (sections.count) ? true : false
        }
    }
    
    /// Choose the sections to be filtered
    @IBAction func chooseSection(_ sender: Any) {
        delegate?.getSessao(with: self.selectedSections)
        self.dismiss(animated: true)
    }
    
    
    /// Check or Uncheck the first cell
    func checkUncheckFirstCell(){
        if let firstCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ModalSectionTableViewCell {
            firstCell.accessoryType = (firstCell.accessoryType == .checkmark) ? .none : .checkmark
        }
    }
    
    /// Load sections
    func pullSections(){
        let url = LinkManager.getUriSections(recurso: "sections")
        FetchService.getRequest(url: url, handler: { (items) in
            self.sections += ResponseService.mapSections(json: items)
            self.todasSelecionadas = self.selectedSections.count == (self.sections.count) ? true : false
            self.tableView.reloadData()
        })
    }
    
}
