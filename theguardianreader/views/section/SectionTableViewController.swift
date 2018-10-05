//
//  SessaoTableViewController.swift
//  theguardianreader
//
//  Created by Henrique Pereira on 18/09/2018.
//  Copyright © 2018 Henrique Pereira. All rights reserved.
//

import UIKit
import JTMaterialSpinner

class SectionTableViewController: UITableViewController {

    var sections = [Section]()
    var spinnerView = JTMaterialSpinner()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        spinnerView.circleLayer.lineWidth = 3.0
        spinnerView.circleLayer.strokeColor = UIColor.black.cgColor
        spinnerView.animationDuration = 1
        self.view.addSubview(spinnerView)
        
        pullSessoes()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) {
            _ in
            self.positionSpinner()
        }
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
        let url = LinkManager.getDomainApikeyResource(resource: "sections")
        beginSpinner()
        FetchService.getRequest(url: url) { (items) in
            self.sections = ResponseService.mapSections(json: items)
            self.stopSpinner()
            self.tableView.reloadData()
        }
    }
}
